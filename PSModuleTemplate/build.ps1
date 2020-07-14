$psake.use_exit_on_error = $true
properties {

    # [String]$DestinationPath = "~\Documents\"
    [String]$Analyze = '.\Module\'
    [String]$Tests = '.\tests\'
    [String]$moduleName = ((Get-ChildItem .\Module\*.psm1).name -split '\.')[0]

}

task default -depends Clean, Analyze, Test, Build

$ParentPath = Split-Path $MyInvocation.MyCommand.Path -Parent
$Leaf = Split-Path $ParentPath -Leaf

$manifest = Test-ModuleManifest -Path ".\Module\$Leaf.psd1"
If($manifest.PowerShellVersion -le 5.99){

    $PSFolder = 'WindowsPowerShell'

} else {

    $PSFolder = 'PowerShell'

}

$DestinationPath = "~\Documents\$PSFolder\Modules\$leaf"
$SourcePath = "$ParentPath\Module\"

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

        If(Get-Module -Name $moduleName -ListAvailable){

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
        Write-Output "PSFolder = $PSFolder"
        Write-Output "PSVersion = $($manifest.PowerShellVersion)"
        Write-Output "DestinationPath = $DestinationPath"
        Write-Output "SourcePath = $SourcePath"

    } catch {

        throw $_

    }

}
