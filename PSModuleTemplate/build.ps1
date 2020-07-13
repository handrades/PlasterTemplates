$psake.use_exit_on_error = $true
properties {

    [String]$ResourceGroup = $null
    [String]$Analyze = '.\src\'
    [String]$Tests = '.\tests\'
    [String]$moduleName = ((Get-ChildItem .\Src\*.psm1).name -split '\.')[0]

}

$ParentPath = Split-Path $MyInvocation.MyCommand.Path -Parent
$Leaf = Split-Path $ParentPath -Leaf

task default -depends Clean, Analyze, Test

task Test {

    try {

        Invoke-Pester -Path $Tests -Output Detailed -Verbose -ErrorAction Stop

    } catch {

        throw $_

    }

    Write-Output 'Executed Test!'

}

task Analyze {

    try {

        Invoke-ScriptAnalyzer -Path $Analyze -Recurse -Verbose -ErrorAction Stop

    } catch {

        throw $_

    }

    Write-Output 'Executed Analyze-Code!'

}

task Clean {

    Try {

        If(Get-Module -Name $moduleName -ListAvailable){
            Remove-Module -Name $moduleName
        }
        #update Manifest with all the functions, aliases and cmdlets to export
        $functionNames = Get-ChildItem -Name .\Src\Src\Public\*.ps1 -File | ForEach-Object {$_ -replace '.ps1',''}
        Update-ModuleManifest -Path ".\Src\$($moduleName).psd1" -FunctionsToExport $functionNames -AliasesToExport '' -CmdletsToExport ''

    } Catch {

        throw $_

    }

    Write-Output 'Executed Clean!'

}

task Variables {

    try {

        Write-Output "ParentPath = $ParentPath"
        Write-Output "Leaf = $Leaf"
        Write-Output "ResourceGroup = $ResourceGroup"
        Write-Output "Template = $Template"
        Write-Output "Parameters = $Parameters"
        Write-Output "moduleName = $moduleName"

    } catch {

        throw $_

    }

    Write-Output "Executed Variables!"

}
