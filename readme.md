## Setup Windows 

Run this:

```sh
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/ThinkOodle/Windows-Setup/master/setup.ps1'))
```

## Setup WSL

After setting up, enter `bash` and run:

``` sh
curl -L https://raw.githubusercontent.com/ThinkOodle/Windows-Setup/master/install-dotfiles.sh | sh
```
