$ErrorActionPreference = 'Stop'
$ProgressPreference = "SilentlyContinue"

# build plugin . . .
Write-Host "Build plugin . . ."
Start-Process -FilePath "./build.bat" -Wait -NoNewWindow

# Move plugin to artifacts
Write-Host "Move plugin to artifacts . . ."
mkdir "out"
Move-Item -Path "./plugin.rbxmx" -Destination "./out/plugin.rbxmx"

# exit
Write-Host "Builds Complete"
exit 0