# Kind Setup for python-app

This directory contains scripts and configuration to set up a local Kubernetes cluster using kind (Kubernetes in Docker).

## Prerequisites

1. **Docker Desktop** - Must be installed and running
2. **kubectl** - Kubernetes command-line tool
   - Install: `winget install -e --id Kubernetes.kubectl`
   - Or download from: https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/
3. **kind** - Installed via `.\install-kind.ps1`
4. **Helm** - Installed via `.\install-helm.ps1` (optional, for package management)

## Quick Start

1. **Install kind** (if not already installed):
   ```powershell
   .\install-kind.ps1
   ```
   This downloads `kind.exe` to the python-app directory.

2. **Install Helm** (optional, for package management):
   ```powershell
   .\install-helm.ps1
   ```
   This downloads `helm.exe` to the python-app directory.

3. **Set up the cluster**:
   ```powershell
   .\setup-kind.ps1
   ```
   This will:
   - Create a kind cluster named `python-app-cluster`
   - Build your Docker image
   - Load the image into the cluster

3. **Use kind**:
   ```powershell
   .\kind.exe get clusters
   .\kind.exe delete cluster --name python-app-cluster
   ```

## Files

- `install-kind.ps1` - Downloads and installs kind.exe to this directory
- `install-helm.ps1` - Downloads and installs helm.exe to this directory
- `setup-kind.ps1` - Sets up the kind cluster and loads your Docker image
- `kind-config.yaml` - Kind cluster configuration (1 control-plane + 1 worker node)
- `kind.exe` - The kind binary (created after running install-kind.ps1)
- `helm.exe` - The Helm binary (created after running install-helm.ps1)

## Using kind

All kind commands should be run with `.\kind.exe` from this directory, or add this directory to your PATH.

```powershell
# Check version
.\kind.exe --version

# List clusters
.\kind.exe get clusters

# Get cluster info
.\kind.exe get kubeconfig --name python-app-cluster

# Delete cluster
.\kind.exe delete cluster --name python-app-cluster

# Using Helm
.\helm.exe --version
.\helm.exe repo list
.\helm.exe install <release-name> <chart>
```

## Notes

- The kind binary is stored locally in the python-app directory
- You can use kind without system-wide installation
- The cluster configuration allows ingress on ports 80 and 443

