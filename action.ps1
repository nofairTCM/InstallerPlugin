$ErrorActionPreference = 'Stop'
$ProgressPreference = "SilentlyContinue"

# tree
Write-Host "Workspace tree :"
tree

# build plugin . . .
Write-Host "Build plugin . . ."
Start-Process -FilePath "./build.bat" -Wait -NoNewWindow

# Move plugin to artifacts
Write-Host "Move plugin to artifacts . . ."
Copy-Item -Path "./plugin.rbxmx" -Destination "$ARTIFACTS/plugin.rbxmx"

# exit
Write-Host "Builds Complete"
exit 0