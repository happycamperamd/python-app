# Install kind (Kubernetes in Docker) for Windows
Write-Host "=== Installing kind for python-app ===" -ForegroundColor Green

$kindVersion = "v0.20.0"
$kindUrl = "https://kind.sigs.k8s.io/dl/$kindVersion/kind-windows-amd64"
$kindPath = Join-Path $PSScriptRoot "kind.exe"

Write-Host ""
Write-Host "Downloading kind $kindVersion..." -ForegroundColor Yellow

try {
    Invoke-WebRequest -Uri $kindUrl -OutFile $kindPath -UseBasicParsing
    Write-Host "kind downloaded successfully" -ForegroundColor Green
    Write-Host ""
    Write-Host "kind installed to: $kindPath" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "To use kind, run it from this directory:" -ForegroundColor Yellow
    Write-Host "  .\kind.exe --version" -ForegroundColor White
    Write-Host "  .\kind.exe create cluster" -ForegroundColor White
} catch {
    Write-Host "ERROR: Failed to download kind" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "You can manually download kind from:" -ForegroundColor Yellow
    Write-Host "https://github.com/kubernetes-sigs/kind/releases" -ForegroundColor Cyan
    exit 1
}
