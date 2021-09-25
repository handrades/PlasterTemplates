Describe "Integration" {
    #import expected data file
    #create shared variables that the context blocks will be using
    #you might add a function under the describe block
    Context "Connection" {
        #you might add a function under the context block
        #you may add BeforeALl{} to stablish a connection for example
        # and/or AfterAll{} to remove the connection
        It "Should be established" {
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
            $false | should -BeFalse
        }
    }

    Context 'Container' {

		It 'Docker container is ready' {
			docker image ls | Select-String PSDashboard | Should -Not -BeNullOrEmpty
		}

	}

}
