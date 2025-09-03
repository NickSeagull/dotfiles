#Requires -RunAsAdministrator
# PowerShell script to check and install WSL2 with Ubuntu if not already installed
# This script runs once and sets up WSL2 with Ubuntu distribution
param(
    [switch]$Force = $false
)

function Test-IsElevated {
  return (New-Object Security.Principal.WindowsPrincipal(
    [Security.Principal.WindowsIdentity]::GetCurrent()))
    .IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if ((Test-IsElevated) -eq $false) {
  Write-Warning "This script requires local admin privileges. Elevating..."
  gsudo "& '$($MyInvocation.MyCommand.Source)'" $args
  if ($LastExitCode -eq 999 ) {
    Write-error 'Failed to elevate.'
  }
  return
}

$ErrorActionPreference = "Stop"

Write-Host "WSL2 and Ubuntu Installation Script" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan

# Function to check if WSL is installed and get version
function Test-WSLInstalled {
    try {
        $wslStatus = wsl --status 2>$null
        if ($LASTEXITCODE -eq 0) {
            return $true
        }
    }
    catch {
        return $false
    }
    return $false
}

# Function to check if Ubuntu is installed
function Test-UbuntuInstalled {
    try {
        # Set proper encoding for WSL output
        $originalEncoding = [Console]::OutputEncoding
        [Console]::OutputEncoding = [System.Text.Encoding]::Unicode
        
        $distributions = wsl --list --quiet 2>$null
        
        # Restore original encoding
        [Console]::OutputEncoding = $originalEncoding
        
        if ($distributions) {
            # Check if Ubuntu is in the list (handles various Ubuntu versions)
            $ubuntuFound = $distributions | Where-Object { $_ -like "*Ubuntu*" }
            if ($ubuntuFound) {
                Write-Host "✓ Ubuntu distribution found: $ubuntuFound" -ForegroundColor Green
                return $true
            }
        }
    }
    catch {
        return $false
    }
    return $false
}

# Function to check if WSL2 is the default version
function Test-WSL2Default {
    try {
        $wslVersion = wsl --status 2>$null | Select-String "Default Version"
        if ($wslVersion -match "2") {
            return $true
        }
    }
    catch {
        return $false
    }
    return $false
}

# Function to check if required Windows features are enabled
function Test-WSLFeaturesEnabled {
    $wslFeature = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
    $vmFeature = Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
    
    return ($wslFeature.State -eq "Enabled" -and $vmFeature.State -eq "Enabled")
}

# Main installation logic
try {
    # Check if WSL features are enabled
    if (-not (Test-WSLFeaturesEnabled)) {
        Write-Host "Enabling required Windows features..." -ForegroundColor Yellow
        
        # Enable Windows Subsystem for Linux
        Write-Host "  - Enabling Windows Subsystem for Linux..." -ForegroundColor Yellow
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All -NoRestart | Out-Null
        
        # Enable Virtual Machine Platform
        Write-Host "  - Enabling Virtual Machine Platform..." -ForegroundColor Yellow
        Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All -NoRestart | Out-Null
        
        Write-Host "✓ Windows features enabled" -ForegroundColor Green
        $restartRequired = $true
    }
    else {
        Write-Host "✓ Required Windows features are already enabled" -ForegroundColor Green
    }
    
    # Check if WSL is installed
    if (-not (Test-WSLInstalled)) {
        Write-Host "Installing WSL..." -ForegroundColor Yellow
        
        # For Windows 10 version 2004+ and Windows 11, use the simplified install command
        $osVersion = [System.Environment]::OSVersion.Version
        if ($osVersion.Build -ge 19041) {
            # Use the modern installation method
            wsl --install --no-launch
            Write-Host "✓ WSL installed" -ForegroundColor Green
        }
        else {
            Write-Host "⚠ Your Windows version requires manual WSL installation" -ForegroundColor Red
            Write-Host "  Please update to Windows 10 version 2004 or higher" -ForegroundColor Red
            exit 1
        }
    }
    else {
        Write-Host "✓ WSL is already installed" -ForegroundColor Green
    }
    
    # Set WSL 2 as default if not already
    if (-not (Test-WSL2Default)) {
        Write-Host "Setting WSL 2 as default version..." -ForegroundColor Yellow
        wsl --set-default-version 2
        Write-Host "✓ WSL 2 set as default" -ForegroundColor Green
    }
    else {
        Write-Host "✓ WSL 2 is already the default version" -ForegroundColor Green
    }
    
    # Check if Ubuntu is installed
    if (-not (Test-UbuntuInstalled) -or $Force) {
        Write-Host "Installing Ubuntu..." -ForegroundColor Yellow
        
        # List available distributions for user reference
        Write-Host "Available distributions:" -ForegroundColor Cyan
        wsl --list --online
        
        # Install Ubuntu (will install latest LTS by default)
        wsl --install -d Ubuntu --no-launch
        
        Write-Host "✓ Ubuntu installation initiated" -ForegroundColor Green
        Write-Host ""
        Write-Host "Note: Ubuntu will complete setup on first launch." -ForegroundColor Yellow
        Write-Host "You'll be prompted to create a username and password." -ForegroundColor Yellow
    }
    else {
        Write-Host "✓ Ubuntu is already installed" -ForegroundColor Green
        
        # Show current WSL distributions
        Write-Host ""
        Write-Host "Current WSL distributions:" -ForegroundColor Cyan
        wsl --list --verbose
    }
    
    # Final status check
    Write-Host ""
    Write-Host "Installation Summary" -ForegroundColor Cyan
    Write-Host "====================" -ForegroundColor Cyan
    
    if (Test-WSLInstalled) {
        Write-Host "✓ WSL is installed and ready" -ForegroundColor Green
    }
    
    if (Test-WSL2Default) {
        Write-Host "✓ WSL 2 is the default version" -ForegroundColor Green
    }
    
    if (Test-UbuntuInstalled) {
        Write-Host "✓ Ubuntu is installed" -ForegroundColor Green
    }
    
    # Check if restart is required
    if ($restartRequired) {
        Write-Host ""
        Write-Host "⚠ RESTART REQUIRED" -ForegroundColor Yellow
        Write-Host "Please restart your computer to complete the installation." -ForegroundColor Yellow
        Write-Host "After restart, run 'ubuntu' in a terminal to complete Ubuntu setup." -ForegroundColor Yellow
    }
    else {
        Write-Host ""
        Write-Host "✓ Setup complete!" -ForegroundColor Green
        Write-Host "Run 'ubuntu' in a terminal to start using Ubuntu on WSL2." -ForegroundColor Cyan
    }
}
catch {
    Write-Host ""
    Write-Host "❌ An error occurred during installation:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting tips:" -ForegroundColor Yellow
    Write-Host "  1. Ensure you're running this script as Administrator" -ForegroundColor Yellow
    Write-Host "  2. Check that virtualization is enabled in BIOS/UEFI" -ForegroundColor Yellow
    Write-Host "  3. Ensure Windows is up to date (version 2004 or higher for Windows 10)" -ForegroundColor Yellow
    Write-Host "  4. Try running 'wsl --update' to update WSL components" -ForegroundColor Yellow
    exit 1
}
