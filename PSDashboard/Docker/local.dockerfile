FROM mcr.microsoft.com/powershell:7.1.4-alpine-3.12-20210819
RUN pwsh -c "Install-Module UniversalDashboard.Community -Acceptlicense -Force"
COPY src .
CMD [ "pwsh","-command","& ./dashboard.ps1" ]
