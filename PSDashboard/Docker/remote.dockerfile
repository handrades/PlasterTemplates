FROM mcr.microsoft.com/powershell:7.1.4-alpine-3.12-20210819
RUN pwsh -c "Install-Module UniversalDashboard.Community -Acceptlicense -Force"
RUN pwsh -c "Invoke-WebRequest -Uri 'https://gist.githubusercontent.com/handrades/82350ab57cae13024c76103084637eb6/raw/b3711c257df9ebe849765176669100959574a2bb/1-UD.ps1' -Method Get -OutFile ./dashboard.ps1"
CMD [ "pwsh","-command","& ./dashboard.ps1" ]
