#!/bin/bash
# AWS Deployment Script for Poll Voting Application
# This script automates the deployment process

set -e

echo "=========================================="
echo "AWS Deployment Script"
echo "Poll Voting Application"
echo "=========================================="

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configuration
AWS_REGION="us-east-1"
EB_APP_NAME="poll-voting-app"
EB_ENV_NAME="poll-voting-backend"
S3_BUCKET="poll-voting-frontend"
RDS_IDENTIFIER="votingapp-db"

echo ""
echo -e "${YELLOW}Step 1: Building Backend...${NC}"
cd backend/votingapp
./mvnw clean package -DskipTests
cd ../..
echo -e "${GREEN}✓ Backend built successfully${NC}"

echo ""
echo -e "${YELLOW}Step 2: Building Frontend...${NC}"
cd frontend/poll-app
npm install
npm run build:prod
cd ../..
echo -e "${GREEN}✓ Frontend built successfully${NC}"

echo ""
echo -e "${YELLOW}Step 3: Deploying Backend to Elastic Beanstalk...${NC}"
eb deploy $EB_ENV_NAME
echo -e "${GREEN}✓ Backend deployed${NC}"

echo ""
echo -e "${YELLOW}Step 4: Uploading Frontend to S3...${NC}"
aws s3 sync frontend/poll-app/dist/poll-app/browser/ s3://$S3_BUCKET/ --delete --acl public-read
echo -e "${GREEN}✓ Frontend uploaded to S3${NC}"

echo ""
echo -e "${YELLOW}Step 5: Getting deployment URLs...${NC}"
BACKEND_URL=$(eb status | grep "CNAME" | awk '{print $2}')
FRONTEND_URL="http://$S3_BUCKET.s3-website-$AWS_REGION.amazonaws.com"

echo ""
echo "=========================================="
echo -e "${GREEN}Deployment Complete!${NC}"
echo "=========================================="
echo ""
echo "Frontend URL: $FRONTEND_URL"
echo "Backend URL: http://$BACKEND_URL"
echo ""
echo "Next steps:"
echo "1. Test your frontend: $FRONTEND_URL"
echo "2. Test your backend: http://$BACKEND_URL/actuator/health"
echo "3. Update CORS_ORIGINS if needed"
echo ""
