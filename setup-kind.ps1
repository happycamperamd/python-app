# Setup kind cluster for python-app
# This script creates a kind cluster and sets up the python-app

param(
    [string]$KindPath = ".\kind.exe"
)

Write-Host "=== Setting up Kind Cluster for python-app ===" -ForegroundColor Green

# Check if kind exists
if (-not (Test-Path $KindPath)) {
    Write-Host "kind.exe not found. Running install script..." -ForegroundColor Yellow
    .\install-kind.ps1
    if (-not (Test-Path $KindPath)) {
        Write-Host "ERROR: kind installation failed" -ForegroundColor Red
        exit 1
    }
}

# Check if Docker is running
Write-Host ""
Write-Host "Checking Docker..." -ForegroundColor Yellow
docker ps | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Docker is not running. Please start Docker Desktop first." -ForegroundColor Red
    exit 1
}
Write-Host "Docker is running" -ForegroundColor Green

# Check if kubectl is installed
Write-Host ""
Write-Host "Checking kubectl..." -ForegroundColor Yellow
$kubectlInstalled = Get-Command kubectl -ErrorAction SilentlyContinue
if (-not $kubectlInstalled) {
    Write-Host "kubectl is not installed. Please install it first:" -ForegroundColor Yellow
    Write-Host "  winget install -e --id Kubernetes.kubectl" -ForegroundColor Cyan
    Write-Host "  Or download from: https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/" -ForegroundColor Cyan
    exit 1
}
Write-Host "kubectl is installed" -ForegroundColor Green

# Delete existing cluster if it exists
Write-Host ""
Write-Host "Checking for existing cluster..." -ForegroundColor Yellow
$existingCluster = & $KindPath get clusters 2>&1 | Select-String -Pattern "python-app-cluster"
if ($existingCluster) {
    Write-Host "Existing cluster found. Deleting..." -ForegroundColor Yellow
    & $KindPath delete cluster --name python-app-cluster
    Write-Host "Cluster deleted" -ForegroundColor Green
}

# Create kind cluster
Write-Host ""
Write-Host "Creating kind cluster..." -ForegroundColor Yellow
& $KindPath create cluster --config kind-config.yaml --name python-app-cluster
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to create cluster" -ForegroundColor Red
    exit 1
}
Write-Host "Cluster created" -ForegroundColor Green

# Build Docker image
Write-Host ""
Write-Host "Building Docker image..." -ForegroundColor Yellow
docker build -t python-app:latest .
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to build Docker image" -ForegroundColor Red
    exit 1
}
Write-Host "Docker image built" -ForegroundColor Green

# Load image into kind cluster
Write-Host ""
Write-Host "Loading Docker image into kind cluster..." -ForegroundColor Yellow
& $KindPath load docker-image python-app:latest --name python-app-cluster
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to load image into cluster" -ForegroundColor Red
    exit 1
}
Write-Host "Image loaded into cluster" -ForegroundColor Green

# Set kubectl context
Write-Host ""
Write-Host "Setting kubectl context..." -ForegroundColor Yellow
kubectl cluster-info --context kind-python-app-cluster
Write-Host "Context set" -ForegroundColor Green

Write-Host ""
Write-Host "=== Cluster Setup Complete ===" -ForegroundColor Green
Write-Host ""
Write-Host "Cluster Information:" -ForegroundColor Cyan
kubectl cluster-info

Write-Host ""
Write-Host "Useful commands:" -ForegroundColor Cyan
Write-Host "  View nodes: kubectl get nodes" -ForegroundColor White
Write-Host "  Delete cluster: .\kind.exe delete cluster --name python-app-cluster" -ForegroundColor White
