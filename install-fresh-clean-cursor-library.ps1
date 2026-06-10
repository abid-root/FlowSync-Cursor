$ErrorActionPreference = "Stop"

$zipName = "flowsync-cursor-library-fresh-clean.zip"

if (!(Test-Path ".\index.html") -or !(Test-Path ".\assets")) {
  throw "Run this inside your current flowsync-cursor-library project folder."
}

if (!(Test-Path ".\$zipName")) {
  throw "Put $zipName inside this folder first, then run this script again."
}

$root = (Get-Location).Path
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backup = Join-Path (Split-Path $root -Parent) "flowsync-before-fresh-clean_$stamp"
$temp = Join-Path $env:TEMP "flowsync-fresh-clean-$stamp"

New-Item -ItemType Directory -Path $backup | Out-Null
Copy-Item ".\index.html",".\assets",".\categories",".\sources",".\README.md" -Destination $backup -Recurse -Force -ErrorAction SilentlyContinue

New-Item -ItemType Directory -Path $temp | Out-Null
Expand-Archive ".\$zipName" -DestinationPath $temp -Force

$fresh = Join-Path $temp "flowsync-cursor-library-fresh"
if (!(Test-Path $fresh)) {
  throw "Fresh project folder not found inside ZIP."
}

Remove-Item ".\assets" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item ".\categories" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item ".\sources" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item ".\index.html" -Force -ErrorAction SilentlyContinue
Remove-Item ".\README.md" -Force -ErrorAction SilentlyContinue

Copy-Item (Join-Path $fresh "assets") ".\assets" -Recurse -Force
Copy-Item (Join-Path $fresh "categories") ".\categories" -Recurse -Force
Copy-Item (Join-Path $fresh "sources") ".\sources" -Recurse -Force
Copy-Item (Join-Path $fresh "index.html") ".\index.html" -Force
Copy-Item (Join-Path $fresh "README.md") ".\README.md" -Force

Remove-Item $temp -Recurse -Force -ErrorAction SilentlyContinue

$node = Get-Command node -ErrorAction SilentlyContinue
if ($node) {
  node --check ".\assets\app.js" | Out-Null
  node --check ".\assets\fx.js" | Out-Null
}

Write-Host "DONE: Fresh clean cursor library installed."
Write-Host "Backup saved here:"
Write-Host $backup
Write-Host "Now open with Live Server and press Ctrl + F5."
