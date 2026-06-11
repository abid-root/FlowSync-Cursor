$ErrorActionPreference = "Stop"

if (!(Test-Path ".\index.html") -or !(Test-Path ".\assets")) {
  throw "Wrong folder. Put this PS1 in your flowsync-cursor-library folder and run it there."
}

$root = (Get-Location).Path
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$zipName = "flowsync-cursor-library-final-fixed.zip"
$zipPath = Join-Path $scriptDir $zipName
if (!(Test-Path $zipPath)) { $zipPath = Join-Path $root $zipName }
if (!(Test-Path $zipPath)) { throw "Cannot find $zipName. Put the ZIP beside this PS1 or inside this project folder." }

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backup = Join-Path (Split-Path $root -Parent) "flowsync-before-final-fix_$stamp"
New-Item -ItemType Directory -Path $backup | Out-Null
Copy-Item ".\index.html",".\assets",".\categories",".\sources",".\README.md" -Destination $backup -Recurse -Force -ErrorAction SilentlyContinue

$temp = Join-Path $env:TEMP "flowsync-final-fix_$stamp"
if (Test-Path $temp) { Remove-Item $temp -Recurse -Force }
New-Item -ItemType Directory -Path $temp | Out-Null
Expand-Archive -Path $zipPath -DestinationPath $temp -Force

$src = Join-Path $temp "flowsync-cursor-library"
if (!(Test-Path $src)) { throw "ZIP structure is wrong. Cannot find flowsync-cursor-library inside the ZIP." }

Remove-Item ".\assets" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item ".\categories" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item ".\sources" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item ".\index.html" -Force -ErrorAction SilentlyContinue
Remove-Item ".\README.md" -Force -ErrorAction SilentlyContinue

Copy-Item (Join-Path $src "assets") ".\assets" -Recurse -Force
Copy-Item (Join-Path $src "categories") ".\categories" -Recurse -Force
Copy-Item (Join-Path $src "sources") ".\sources" -Recurse -Force
Copy-Item (Join-Path $src "index.html") ".\index.html" -Force
if (Test-Path (Join-Path $src "README.md")) { Copy-Item (Join-Path $src "README.md") ".\README.md" -Force }

Remove-Item $temp -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "DONE: Coldboot cursor library fixed."
Write-Host "Backup saved here:"
Write-Host $backup
Write-Host "Now press Ctrl + F5 in the browser."
