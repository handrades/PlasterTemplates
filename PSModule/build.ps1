$psake.use_exit_on_error = $true
properties {

    [String]$DeployDestination = "~\Downloads\"
    [String]$Analyze = '.\Module\'
    [String]$Tests = '.\tests\'

}

task default -depends Clean, Analyze, Test, Build, VersionControl, Deploy

$ParentPath = Split-Path $MyInvocation.MyCommand.Path -Parent
$Leaf = Split-Path $ParentPath -Leaf

$moduleName = ((Get-ChildItem .\Module\*.psm1).name -split '\.')[0]
$manifest = Test-ModuleManifest -Path ".\Module\$moduleName.psd1"
$Build = $Manifest.Version.Build + 1
[System.Version]$ModuleVersion = "$($Manifest.Version.Major).$($Manifest.Version.Minor).$Build"

If($manifest.PowerShellVersion -le 5.99){

    $PSFolder = 'WindowsPowerShell'

} else {

    $PSFolder = 'PowerShell'

}

$DestinationPath = "~\Documents\$PSFolder\Modules\$moduleName"
$SourcePath = "$ParentPath\Module\"

task deploy {

    Try {

        $ZipFileName = "$moduleName-$ModuleVersion"
        $ZipFileFullPath = "$DeployDestination\$ZipFileName.zip"
        $compress = @{
            Path = "$SourcePath\*"
            DestinationPath = $ZipFileFullPath
            CompressionLevel = 'Fastest'
            Force = $true
            ErrorAction = 'Stop'
        }
        Compress-Archive @compress

        $FileHash = Get-FileHash -Path $ZipFileFullPath -Algorithm SHA512 -ErrorAction Stop
        New-Item -Path $DeployDestination -ItemType File -Name "$ZipFileName-Checksum.txt" -Value $FileHash.Hash

    } Catch {

        throw $_

    }

}

task VersionControl {

    if($CommitMessage){
        Try {

            $CommitCode = $true
            switch -regex (git status){
                'nothing to commit, working tree clean'{$CommitCode = $false}
            }

            If($CommitCode){

                Update-ModuleManifest -Path ".\Module\$($moduleName).psd1" -ModuleVersion $ModuleVersion -ErrorAction Stop

                git add .
                git tag -a "v$ModuleVersion" -m "Version $ModuleVersion"
                git commit -m "$CommitMessage"

            } else {

                Write-Output "No changes found. Your commit message '$CommitMessage' will not be applied."

            }

        } Catch {

            throw $_

        }

    } else {

        throw 'Add "-parameters @{"CommitMessage"="Your commit message";}" If you are want to increase the build number'

    }

}

task Build {

    Try {

        Copy-Item -Path $SourcePath -Destination $DestinationPath -Force -Recurse -ErrorAction Stop

    } Catch {

        throw $_

    }

}

task Test {

    try {

        Invoke-Pester -Path $Tests -Output Detailed -Verbose -ErrorAction Stop

    } catch {

        throw $_

    }

}

task Analyze {

    try {

        Invoke-ScriptAnalyzer -Path $Analyze -Recurse -Verbose -ErrorAction Stop

    } catch {

        throw $_

    }

}

task Clean {

    Try {

        If(Get-Module -Name $moduleName){

            Remove-Module -Name $moduleName -ErrorAction Stop

        }

        If(Test-Path -Path $DestinationPath -ErrorAction Stop){

            Remove-Item -Path $DestinationPath -Force -Recurse -ErrorAction Stop

        }

        #update Manifest with all the functions, aliases and cmdlets to export
        $functionNames = Get-ChildItem -Name .\Module\Src\Public\*.ps1 -File -ErrorAction Stop | ForEach-Object {$_ -replace '.ps1',''}
        Update-ModuleManifest -Path ".\Module\$($moduleName).psd1" -FunctionsToExport $functionNames -AliasesToExport '' -CmdletsToExport '' -ErrorAction Stop

    } Catch {

        throw $_

    }

}

task Variables {

    try {

        Write-Output "ParentPath = $ParentPath"
        Write-Output "Leaf = $Leaf"
        Write-Output "Parameters = $Parameters"
        Write-Output "moduleName = $moduleName"
        Write-Output "ModuleVersion = $ModuleVersion"
        Write-Output "PSFolder = $PSFolder"
        Write-Output "PSVersion = $($manifest.PowerShellVersion)"
        Write-Output "DestinationPath = $DestinationPath"
        Write-Output "SourcePath = $SourcePath"
        Write-Output "DeployDestination = $DeployDestination"
        Write-Output "CommitMessage = $CommitMessage"

    } catch {

        throw $_

    }

}
