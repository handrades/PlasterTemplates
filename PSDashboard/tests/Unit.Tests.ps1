$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Split-Path -Path $here -Parent

Describe "Unit" {
    #import expected data file
    #create shared variables that the context blocks will be using
    #you might add a function under the describe block
    Context "Logic" {
        #you might add a function under the context block
        #you may add BeforeALl{} to stablish a connection for example
        # and/or AfterAll{} to remove the connection
        It "`$true should be 'True'" {
            #check if all prereqs/dependencies are in place before running test
            #such as module dependencies are installed
            #such as if the server is online, if it is offline
            #if the prereq/dependency check fails set the test as inconclusive
            $PreReqs = @(
                {-not ($true)}
                {-not ($true)}
            )

            $PreReqs.ForEach({
                if (& $_) {
                    Set-ItResult -Inconclusive -Because 'a pre-requirement was not met'
                }
            })

            #you write the actual tests
            $true | should -BeTrue
        }

    }

	Context 'PS1 files' {

		It 'Dashboard.ps1 exists' {
			ls .\src | where {$_.Name -eq 'dashboard.ps1'} | should -Not -BeNullOrEmpty
		}

	}

}
