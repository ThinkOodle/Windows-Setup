iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/ThinkOodle/Windows-Setup/master/apps.config")) | Out-File -FilePath apps.config
choco install .\apps.config -y
rm .\apps.config

Write-host "Would you like to install dev apps?" -ForegroundColor Yellow 
$Readhost = Read-Host " ( y / n ) " 
Switch ($ReadHost) 
  { 
    Y {Write-host "Yes, Install dev apps"; ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/ThinkOodle/Windows-Setup/master/dev-apps.config")) | Out-File -FilePath apps.config; choco install .\apps.config -y; rm .\apps.config; iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/ThinkOodle/Windows-Setup/master/dev.ps1"))} 
    N {Write-Host "No, don't install dev apps";} 
    Default {Write-Host "No, don't install dev apps";} 
  } 
