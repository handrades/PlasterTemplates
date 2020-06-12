<%
@"
function $PLASTER_PARAM_ModuleFunctionName {
"@
%>
    [CmdletBinding()]
    param (
        #Enter computer name or IP address
        [string[]]$ComputerName
    )

    begin {

        $OnlineComputers = @()
        $OfflineComputers = @()
        foreach ($Computer in $ComputerName) {
            if (Test-Connection -ComputerName $Computer -Count 1 -Quiet -ErrorAction SilentlyContinue) {
                $OnlineComputers += $Computer
            }
            Else {
                $OfflineComputers += $Computer
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