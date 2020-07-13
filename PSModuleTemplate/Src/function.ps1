<%
@"
function $PLASTER_PARAM_ModuleFunctionName {
"@
%>
    [CmdletBinding()]
    param (
        #Enter computer name or IP address
        [Parameter(Mandatory=$true,
            Position=0,
            ValueFromPipelineByPropertyName=$true)]
        [string[]]$ComputerName
    )

    begin {

        [System.Collections.ArrayList]$OnlineComputers = @()
        [System.Collections.ArrayList]$OfflineComputers = @()
        foreach ($Computer in $ComputerName) {
            if (Test-Connection -ComputerName $Computer -Count 1 -Quiet -ErrorAction SilentlyContinue) {
                $OnlineComputers.Add($Computer)
            } Else {
                $OfflineComputers.Add($Computer)
            }
        }

    }

    process {

        $OnlineComputers | ForEach-Object {

            Try {

                $OnlineComputer = $_

                # Your code goes below this line

                $Props = [ordered]@{
                    ComputerName     = $OnlineComputer
                    Status           = 'Online'
                }

                New-Object -TypeName psobject -Property $Props

            } Catch {

                $_

            }
        }

        $OfflineComputers | ForEach-Object -parallel {

            Try {

                $OfflineComputer = $_

                # Your code goes below this line

                $Props = [ordered]@{
                    ComputerName     = $OfflineComputer
                    Status           = 'Offline'
                }

                New-Object -TypeName psobject -Property $Props

            } Catch {

                $_

            }

        }

    }

}