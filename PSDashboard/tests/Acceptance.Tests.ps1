Describe "Acceptance" {
    #import expected data file
    #create shared variables that the context blocks will be using
    #you might add a function under the describe block
    Context "WebApp v0.1" {
        #you might add a function under the context block
        #you may add BeforeALl{} to stablish a connection for example
        # and/or AfterAll{} to remove the connection
        It "Port 80 open" {
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
            (Test-NetConnection localhost -Port 80).TcpTestSucceeded | Should -BeTrue
        }

        It "Status Code 200 on port 80" {

            #you write the actual tests
            (Invoke-WebRequest -Uri http://localhost).statuscode | Should -Be '200'
        }

    }

    Context "WebApp v0.2" {
        #you might add a function under the context block
        #you may add BeforeALl{} to stablish a connection for example
        # and/or AfterAll{} to remove the connection
        It "Port 81 open" {
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
            (Test-NetConnection localhost -Port 81).TcpTestSucceeded | Should -BeTrue
        }

        It "Status Code 200 on port 81" {

            #you write the actual tests
            (Invoke-WebRequest -Uri http://localhost:81).statuscode | Should -Be '200'
        }
    }
}
