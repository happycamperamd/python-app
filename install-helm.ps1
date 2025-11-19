# Install Helm for Windows
# This script downloads and installs Helm to the python-app directory

Write-Host "=== Installing Helm for python-app ===" -ForegroundColor Green

$helmVersion = "v3.13.0"
$helmUrl = "https://get.helm.sh/helm-$helmVersion-windows-amd64.zip"
$helmZipPath = Join-Path $PSScriptRoot "helm.zip"
$helmExtractPath = Join-Path $PSScriptRoot "helm-temp"
$helmExePath = Join-Path $PSScriptRoot "helm.exe"

Write-Host ""
Write-Host "Downloading Helm $helmVersion..." -ForegroundColor Yellow

try {
    # Download Helm
    Invoke-WebRequest -Uri $helmUrl -OutFile $helmZipPath -UseBasicParsing
    Write-Host "Helm downloaded successfully" -ForegroundColor Green
    
    # Extract Helm
    Write-Host "Extracting Helm..." -ForegroundColor Yellow
    if (Test-Path $helmExtractPath) {
        Remove-Item -Path $helmExtractPath -Recurse -Force
    }
    Expand-Archive -Path $helmZipPath -DestinationPath $helmExtractPath -Force
    
    # Find and copy helm.exe
    $helmExeSource = Get-ChildItem -Path $helmExtractPath -Filter "helm.exe" -Recurse | Select-Object -First 1
    if ($helmExeSource) {
        Copy-Item -Path $helmExeSource.FullName -Destination $helmExePath -Force
        Write-Host "Helm extracted successfully" -ForegroundColor Green
    } else {
        throw "helm.exe not found in extracted archive"
    }
    
    # Cleanup
    Remove-Item -Path $helmZipPath -Force
    Remove-Item -Path $helmExtractPath -Recurse -Force
    
    Write-Host ""
    Write-Host "Helm installed to: $helmExePath" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "To use Helm, run it from this directory:" -ForegroundColor Yellow
    Write-Host "  .\helm.exe --version" -ForegroundColor White
    Write-Host "  .\helm.exe repo add <name> <url>" -ForegroundColor White
    Write-Host ""
    Write-Host "Or add this directory to your PATH to use 'helm' from anywhere." -ForegroundColor Yellow
    
} catch {
    Write-Host "ERROR: Failed to install Helm" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "You can manually download Helm from:" -ForegroundColor Yellow
    Write-Host "https://github.com/helm/helm/releases" -ForegroundColor Cyan
    exit 1
}

