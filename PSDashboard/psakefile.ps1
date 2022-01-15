$psake.use_exit_on_error = $true

properties {

    [String]$Container = 'psdashboard'.ToLower()
    $DeployMessage = 'Executed Deploy!'
    $testMessage = 'Executed Test!'
    $cleanMessage = 'Executed Clean!'
    $BuildMessage = 'Executed Build!'

}

task default -depends Clean, Build, UnitTest, Deploy, IntegrationTest, AcceptanceTest

task AcceptanceTest -depends IntegrationTest {

    Try {

        'Acceptance Tests'
        Invoke-Pester ".\Tests\Acceptance.Tests.ps1" -Output Detailed

    } Catch {

        $_

    }

    $testMessage

}

task IntegrationTest -depends Deploy {

    Try {

        'Integration Tests'
        Invoke-Pester ".\Tests\Integration.Tests.ps1" -Output Detailed

    } Catch {

        $_

    }

    $testMessage

}

task Deploy -depends UnitTest {

    Try {

        docker run -d -p 80:80 $(-join ($Container,':0.1'))
        docker run -d -p 81:80 $(-join ($Container,':0.2'))
        Start-Process http://localhost
        Start-Sleep -Seconds 3
        Start-Process http://localhost:81

    } Catch {

        $_

    }

    $DeployMessage

}

task UnitTest -depends Build {

    Try {

        'Unit Tests'
        Invoke-Pester ".\Tests\Unit.Tests.ps1" -Output Detailed

    } Catch {

        $_

    }

    $testMessage

}

task Build -depends Clean{

    Try {

        docker build -t $(-join ($Container,':0.1')) -f .\Docker\remote.dockerfile .
        docker build -t $(-join ($Container,':0.2')) -f .\Docker\local.dockerfile .

    } Catch {

        $_

    }

    $BuildMessage

}

task Clean {

    Try {

        while((docker ps -a | Select-String $Container) -split '  '){
            docker stop $(((docker ps -a | Select-String $Container) -split '  ')[0])
            docker rm $(((docker ps -a | Select-String $Container) -split '  ')[0])
        }

        if((docker image ls --format '{{.ID}}\t{{.Repository}}' | Select-String $Container)){
            docker rmi $((docker image ls --format '{{.ID}}\t{{.Repository}}' | Select-String $Container) | %{($_ -split '\t')[0]}) -f
        }

    } Catch {

        $_

    }

    $cleanMessage

}