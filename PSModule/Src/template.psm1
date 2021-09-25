#Unblock files.
Get-ChildItem -Path $PSScriptRoot -Recurse | Unblock-File
<%
    if ($PLASTER_PARAM_ModuleFolders -contains 'Classes')
    {
@"

#Add the classes required for the module.
Get-ChildItem -Path $PSScriptRoot\Classes\*.cs | ForEach-Object {
    try
    {
        Add-Type -Path $_.FullName -ErrorAction Stop
    }
    catch
    {
        throw
    }
}

"@
    }
%>
#stole this code from the Lability PowerShell module, it is very useful
## Import the \Src files. This permits loading of the module's functions for unit testing, without having to unload/load the module.

$moduleRoot = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
$moduleSrcPath = Join-Path -Path $moduleRoot -ChildPath 'Src'

Get-ChildItem -Path $moduleSrcPath -Include *.ps1 -Exclude '*.Tests.ps1' -Recurse |
    ForEach-Object {
        Write-Verbose -Message ('Importing library\source file ''{0}''.' -f $_.FullName)
        ## https://becomelotr.wordpress.com/2017/02/13/expensive-dot-sourcing/
        . ([System.Management.Automation.ScriptBlock]::Create(
                [System.IO.File]::ReadAllText($_.FullName)
            ))
    }
