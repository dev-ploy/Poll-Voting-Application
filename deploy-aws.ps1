# AWS Deployment PowerShell Script
# Poll Voting Application - Automated Deployment

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "AWS Deployment Script" -ForegroundColor Cyan
Write-Host "Poll Voting Application" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$AWS_REGION = "us-east-1"
$EB_APP_NAME = "poll-voting-app"
$EB_ENV_NAME = "poll-voting-backend"
$S3_BUCKET = "poll-voting-frontend"

# Function to check if command exists
function Test-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# Check prerequisites
Write-Host "Checking prerequisites..." -ForegroundColor Yellow

if (-not (Test-Command aws)) {
    Write-Host "✗ AWS CLI not found. Please install it first." -ForegroundColor Red
    Write-Host "Run: .\setup-aws-tools.ps1" -ForegroundColor Yellow
    exit 1
}

if (-not (Test-Command eb)) {
    Write-Host "✗ EB CLI not found. Please install it first." -ForegroundColor Red
    Write-Host "Run: pip install awsebcli" -ForegroundColor Yellow
    exit 1
}

Write-Host "✓ Prerequisites met" -ForegroundColor Green
Write-Host ""

# Step 1: Build Backend
Write-Host "Step 1: Building Backend..." -ForegroundColor Yellow
Push-Location backend\votingapp
try {
    .\mvnw.cmd clean package -DskipTests
    Write-Host "✓ Backend built successfully" -ForegroundColor Green
} catch {
    Write-Host "✗ Backend build failed" -ForegroundColor Red
    exit 1
} finally {
    Pop-Location
}
Write-Host ""

# Step 2: Build Frontend
Write-Host "Step 2: Building Frontend..." -ForegroundColor Yellow
Push-Location frontend\poll-app
try {
    npm install
    npm run build:prod
    Write-Host "✓ Frontend built successfully" -ForegroundColor Green
} catch {
    Write-Host "✗ Frontend build failed" -ForegroundColor Red
    exit 1
} finally {
    Pop-Location
}
Write-Host ""

# Step 3: Deploy Backend
Write-Host "Step 3: Deploying Backend to Elastic Beanstalk..." -ForegroundColor Yellow
try {
    eb deploy $EB_ENV_NAME
    Write-Host "✓ Backend deployed" -ForegroundColor Green
} catch {
    Write-Host "✗ Backend deployment failed" -ForegroundColor Red
    Write-Host "Make sure you have initialized EB with: eb init" -ForegroundColor Yellow
    exit 1
}
Write-Host ""

# Step 4: Deploy Frontend
Write-Host "Step 4: Uploading Frontend to S3..." -ForegroundColor Yellow
try {
    aws s3 sync frontend\poll-app\dist\poll-app\browser\ s3://$S3_BUCKET/ --delete --acl public-read
    Write-Host "✓ Frontend uploaded to S3" -ForegroundColor Green
} catch {
    Write-Host "✗ Frontend upload failed" -ForegroundColor Red
    Write-Host "Make sure the S3 bucket exists: $S3_BUCKET" -ForegroundColor Yellow
    exit 1
}
Write-Host ""

# Step 5: Get URLs
Write-Host "Step 5: Getting deployment URLs..." -ForegroundColor Yellow
$BACKEND_URL = (eb status | Select-String "CNAME" | ForEach-Object { $_.ToString().Split()[1] })
$FRONTEND_URL = "http://$S3_BUCKET.s3-website-$AWS_REGION.amazonaws.com"

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Deployment Complete!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Frontend URL: $FRONTEND_URL" -ForegroundColor Cyan
Write-Host "Backend URL: http://$BACKEND_URL" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Test your frontend: $FRONTEND_URL"
Write-Host "2. Test your backend: http://$BACKEND_URL/actuator/health"
Write-Host "3. Update CORS_ORIGINS if needed: eb setenv CORS_ORIGINS=`"$FRONTEND_URL`""
Write-Host ""
Write-Host "To view logs: eb logs" -ForegroundColor Yellow
Write-Host "To open in browser: eb open" -ForegroundColor Yellow
Write-Host ""
