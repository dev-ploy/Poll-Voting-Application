# AWS Deployment Setup Script
# Run this script to install AWS CLI and Elastic Beanstalk CLI

Write-Host "Installing AWS Tools..." -ForegroundColor Green

# Install AWS CLI using MSI installer
Write-Host "`nStep 1: Download and install AWS CLI v2..." -ForegroundColor Yellow
$awsCliUrl = "https://awscli.amazonaws.com/AWSCLIV2.msi"
$output = "$env:TEMP\AWSCLIV2.msi"

Write-Host "Downloading AWS CLI..."
Invoke-WebRequest -Uri $awsCliUrl -OutFile $output

Write-Host "Installing AWS CLI (this may take a few minutes)..."
Start-Process msiexec.exe -Wait -ArgumentList "/i $output /quiet"

Write-Host "`nAWS CLI installed successfully!" -ForegroundColor Green
Write-Host "Please close and reopen PowerShell, then run: aws --version" -ForegroundColor Cyan

# Install EB CLI using pip
Write-Host "`nStep 2: Installing Elastic Beanstalk CLI..." -ForegroundColor Yellow
Write-Host "First, checking if Python is installed..."

try {
    $pythonVersion = python --version 2>&1
    Write-Host "Python found: $pythonVersion" -ForegroundColor Green
    
    Write-Host "`nInstalling EB CLI via pip..."
    pip install awsebcli --upgrade --user
    
    Write-Host "`nEB CLI installed successfully!" -ForegroundColor Green
    Write-Host "Run: eb --version to verify" -ForegroundColor Cyan
} catch {
    Write-Host "Python not found. Please install Python 3.7+ from https://www.python.org/downloads/" -ForegroundColor Red
    Write-Host "Then run this script again." -ForegroundColor Red
}

Write-Host "`n=== Installation Complete ===" -ForegroundColor Green
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Close and reopen PowerShell"
Write-Host "2. Run: aws --version"
Write-Host "3. Run: eb --version"
Write-Host "4. Run: aws configure (to setup your credentials)"
