# AWS Deployment Guide - Poll Voting Application

## Complete Step-by-Step Guide to Deploy on AWS

---

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Setup AWS Account](#setup-aws-account)
3. [Deploy MySQL Database (RDS)](#deploy-mysql-database-rds)
4. [Deploy Backend (Elastic Beanstalk)](#deploy-backend-elastic-beanstalk)
5. [Deploy Frontend (S3 + CloudFront)](#deploy-frontend-s3--cloudfront)
6. [Configure Domain & SSL](#configure-domain--ssl-optional)
7. [Monitoring & Maintenance](#monitoring--maintenance)

---

## Prerequisites

### Required Tools
- AWS Account (Free Tier eligible)
- AWS CLI v2
- EB CLI (Elastic Beanstalk CLI)
- Git
- Maven (for backend build)
- Node.js & npm (for frontend build)

### Installation Steps

**1. Install AWS CLI:**
```powershell
# Run the setup script
.\setup-aws-tools.ps1

# Or manually download from:
# https://awscli.amazonaws.com/AWSCLIV2.msi
```

**2. Install EB CLI:**
```powershell
pip install awsebcli --upgrade --user
```

**3. Configure AWS Credentials:**
```powershell
aws configure
```
You'll need:
- AWS Access Key ID
- AWS Secret Access Key
- Default region (e.g., us-east-1)
- Default output format (json)

---

## Part 1: Deploy MySQL Database (RDS)

### Step 1: Create RDS MySQL Instance

**Using AWS Console:**

1. Go to AWS Console: https://console.aws.amazon.com
2. Navigate to **RDS** service
3. Click **"Create database"**

**Database Configuration:**
```
Engine: MySQL
Version: MySQL 8.0.35 (or latest)
Template: Free tier

Settings:
  DB instance identifier: votingapp-db
  Master username: admin
  Master password: [create strong password - save it!]

DB Instance Class:
  Burstable classes: db.t3.micro (Free tier eligible)

Storage:
  Storage type: General Purpose SSD (gp2)
  Allocated storage: 20 GB
  Enable storage autoscaling: Yes
  Maximum storage threshold: 100 GB

Connectivity:
  VPC: Default VPC
  Public access: Yes (for testing)
  VPC security group: Create new
  Security group name: votingapp-db-sg
  Availability Zone: No preference

Database authentication:
  Password authentication

Additional configuration:
  Initial database name: votingapp
  Backup retention period: 7 days
  Enable automated backups: Yes
  
Encryption: Disabled (for free tier)
```

4. Click **"Create database"**
5. Wait 5-10 minutes for creation

### Step 2: Configure Security Group

1. Go to **EC2** → **Security Groups**
2. Find `votingapp-db-sg`
3. Click **"Edit inbound rules"**
4. Add rule:
   ```
   Type: MySQL/Aurora
   Protocol: TCP
   Port: 3306
   Source: Anywhere-IPv4 (0.0.0.0/0) - For testing only!
   ```
   **⚠️ For production, restrict to your backend security group**

### Step 3: Get Database Connection Details

1. Go to RDS → Databases → votingapp-db
2. Copy the **Endpoint**:
   ```
   votingapp-db.xxxxxxxxx.us-east-1.rds.amazonaws.com
   ```
3. Save connection details:
   ```
   Host: votingapp-db.xxxxxxxxx.us-east-1.rds.amazonaws.com
   Port: 3306
   Database: votingapp
   Username: admin
   Password: [your password]
   ```

### Step 4: Test Connection (Optional)

```powershell
# Install MySQL client
# Download from: https://dev.mysql.com/downloads/mysql/

mysql -h votingapp-db.xxxxxxxxx.us-east-1.rds.amazonaws.com -P 3306 -u admin -p
# Enter password when prompted
```

---

## Part 2: Deploy Backend (Elastic Beanstalk)

### Step 1: Build Backend JAR

```powershell
cd E:\Voting-App\backend\votingapp

# Build the application
.\mvnw clean package -DskipTests

# Verify JAR created
ls target\*.jar
# Should see: votingapp-0.0.1-SNAPSHOT.jar
```

### Step 2: Initialize Elastic Beanstalk

```powershell
cd E:\Voting-App

# Initialize EB
eb init

# Follow prompts:
# Select region: us-east-1
# Application name: poll-voting-app
# Platform: Java
# Platform version: Corretto 17
# CodeCommit: No
# SSH: Yes (recommended)
```

### Step 3: Create EB Environment

```powershell
eb create poll-voting-backend

# Options:
# Environment name: poll-voting-backend
# DNS CNAME prefix: poll-voting-backend
# Load balancer: application
```

### Step 4: Configure Environment Variables

```powershell
# Set environment variables
eb setenv \
  SERVER_PORT=8080 \
  SPRING_PROFILES_ACTIVE=production \
  DATABASE_URL="jdbc:mysql://votingapp-db.xxxxxxxxx.us-east-1.rds.amazonaws.com:3306/votingapp" \
  DB_USERNAME=admin \
  DB_PASSWORD="your-password-here" \
  CORS_ORIGINS="http://poll-voting-frontend.s3-website-us-east-1.amazonaws.com"
```

**Or via AWS Console:**
1. Go to Elastic Beanstalk → Environments → poll-voting-backend
2. Click **Configuration** → **Software** → **Edit**
3. Add environment properties:
   - `SERVER_PORT` = `8080`
   - `SPRING_PROFILES_ACTIVE` = `production`
   - `DATABASE_URL` = `jdbc:mysql://[RDS-ENDPOINT]:3306/votingapp`
   - `DB_USERNAME` = `admin`
   - `DB_PASSWORD` = `[your-password]`
   - `CORS_ORIGINS` = `[will update after frontend deploy]`

### Step 5: Deploy Backend

```powershell
# Package the application
cd backend\votingapp
.\mvnw clean package -DskipTests

# Deploy to EB
cd ..\..
eb deploy
```

### Step 6: Get Backend URL

```powershell
eb status

# Or
eb open
```

Your backend URL will be:
```
http://poll-voting-backend.us-east-1.elasticbeanstalk.com
```

### Step 7: Test Backend

```powershell
# Test health endpoint
curl http://poll-voting-backend.us-east-1.elasticbeanstalk.com/actuator/health

# Test API
curl http://poll-voting-backend.us-east-1.elasticbeanstalk.com/api/polls
```

---

## Part 3: Deploy Frontend (S3 + CloudFront)

### Step 1: Update Frontend Environment

Edit: `frontend\poll-app\src\environments\environment.prod.ts`

```typescript
export const environment = {
  production: true,
  apiUrl: 'http://poll-voting-backend.us-east-1.elasticbeanstalk.com'
};
```

### Step 2: Build Frontend

```powershell
cd E:\Voting-App\frontend\poll-app

# Install dependencies
npm install

# Build for production
npm run build:prod

# Verify build
ls dist\poll-app\browser
```

### Step 3: Create S3 Bucket

**Using AWS Console:**

1. Go to **S3** service
2. Click **"Create bucket"**

**Bucket Configuration:**
```
Bucket name: poll-voting-frontend (must be globally unique)
Region: us-east-1 (same as backend)

Object Ownership: ACLs disabled

Block Public Access:
  ⚠️ UNCHECK "Block all public access"
  ✅ Acknowledge warning

Bucket Versioning: Disable
Default encryption: Disable (for free tier)
```

3. Click **"Create bucket"**

### Step 4: Upload Frontend Files

**Using AWS Console:**

1. Open bucket: `poll-voting-frontend`
2. Click **"Upload"**
3. Drag and drop all files from:
   ```
   E:\Voting-App\frontend\poll-app\dist\poll-app\browser\
   ```
4. Click **"Upload"**

**Using AWS CLI:**

```powershell
cd E:\Voting-App\frontend\poll-app

aws s3 sync dist/poll-app/browser/ s3://poll-voting-frontend/ --acl public-read
```

### Step 5: Enable Static Website Hosting

1. Go to bucket → **Properties** tab
2. Scroll to **"Static website hosting"**
3. Click **"Edit"**
4. Configure:
   ```
   Static website hosting: Enable
   Hosting type: Host a static website
   Index document: index.html
   Error document: index.html
   ```
5. Click **"Save changes"**
6. Note the **Bucket website endpoint**:
   ```
   http://poll-voting-frontend.s3-website-us-east-1.amazonaws.com
   ```

### Step 6: Configure Bucket Policy

1. Go to bucket → **Permissions** tab
2. Scroll to **"Bucket policy"**
3. Click **"Edit"**
4. Add this policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::poll-voting-frontend/*"
    }
  ]
}
```

5. Click **"Save changes"**

### Step 7: Test Frontend

Open in browser:
```
http://poll-voting-frontend.s3-website-us-east-1.amazonaws.com
```

### Step 8: Update Backend CORS

Go back to Elastic Beanstalk and update `CORS_ORIGINS`:

```powershell
eb setenv CORS_ORIGINS="http://poll-voting-frontend.s3-website-us-east-1.amazonaws.com"
```

---

## Part 4: Setup CloudFront (CDN) - Optional but Recommended

### Step 1: Create CloudFront Distribution

1. Go to **CloudFront** service
2. Click **"Create distribution"**

**Origin Configuration:**
```
Origin domain: poll-voting-frontend.s3-website-us-east-1.amazonaws.com
Origin path: (leave empty)
Name: poll-frontend-s3
Protocol: HTTP only

Origin access: Public
```

**Default cache behavior:**
```
Viewer protocol policy: Redirect HTTP to HTTPS
Allowed HTTP methods: GET, HEAD, OPTIONS
Cache policy: CachingOptimized
```

**Settings:**
```
Price class: Use all edge locations (best performance)
Alternate domain name (CNAME): (optional - if you have domain)
Default root object: index.html
```

3. Click **"Create distribution"**
4. Wait 10-15 minutes for deployment
5. Copy **Distribution domain name**:
   ```
   d1234567890abc.cloudfront.net
   ```

### Step 2: Configure Error Pages

1. Go to CloudFront → Your distribution
2. Click **"Error pages"** tab
3. Click **"Create custom error response"**
4. Configure:
   ```
   HTTP error code: 404
   Customize error response: Yes
   Response page path: /index.html
   HTTP response code: 200
   ```
5. Repeat for error code 403

### Step 3: Update Backend CORS for CloudFront

```powershell
eb setenv CORS_ORIGINS="https://d1234567890abc.cloudfront.net"
```

---

## Part 5: Monitoring & Maintenance

### CloudWatch Logs

**Backend Logs:**
1. Go to Elastic Beanstalk → poll-voting-backend
2. Click **"Logs"** → **"Request logs"** → **"Last 100 Lines"**

**RDS Monitoring:**
1. Go to RDS → votingapp-db
2. Click **"Monitoring"** tab
3. View CPU, connections, storage metrics

### Cost Monitoring

1. Go to **AWS Billing Dashboard**
2. Check **"Bills"** section
3. Monitor free tier usage

### Free Tier Limits

- **RDS MySQL**: 750 hours/month (db.t3.micro)
- **EC2** (for EB): 750 hours/month (t2.micro)
- **S3**: 5 GB storage, 20,000 GET requests
- **CloudFront**: 1 TB data transfer out

---

## Part 6: CI/CD with GitHub Actions (Optional)

Create `.github/workflows/aws-deploy.yml`:

```yaml
name: Deploy to AWS

on:
  push:
    branches: [ main ]

jobs:
  deploy-backend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Java
        uses: actions/setup-java@v3
        with:
          java-version: '17'
          distribution: 'corretto'
      
      - name: Build Backend
        run: |
          cd backend/votingapp
          ./mvnw clean package -DskipTests
      
      - name: Deploy to Elastic Beanstalk
        uses: einaregilsson/beanstalk-deploy@v21
        with:
          aws_access_key: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws_secret_key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          application_name: poll-voting-app
          environment_name: poll-voting-backend
          version_label: ${{ github.sha }}
          region: us-east-1
          deployment_package: backend/votingapp/target/votingapp-0.0.1-SNAPSHOT.jar

  deploy-frontend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      
      - name: Build Frontend
        run: |
          cd frontend/poll-app
          npm install
          npm run build:prod
      
      - name: Deploy to S3
        run: |
          aws s3 sync frontend/poll-app/dist/poll-app/browser/ s3://poll-voting-frontend/ --delete
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_DEFAULT_REGION: us-east-1
      
      - name: Invalidate CloudFront
        run: |
          aws cloudfront create-invalidation --distribution-id YOUR_DISTRIBUTION_ID --paths "/*"
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_DEFAULT_REGION: us-east-1
```

---

## Troubleshooting

### Backend won't start
```powershell
# Check logs
eb logs

# SSH into instance
eb ssh

# Check Java version
java -version
```

### Database connection failed
- Verify security group allows port 3306
- Check RDS endpoint is correct
- Verify credentials in environment variables
- Test connection from EC2 instance

### Frontend shows CORS error
- Update CORS_ORIGINS in backend environment variables
- Ensure protocol (http/https) matches
- Check browser console for specific error

### High AWS costs
- Check CloudWatch billing alerts
- Verify you're using free tier eligible services
- Stop/delete unused resources

---

## Cleanup (To avoid charges)

```powershell
# Delete Elastic Beanstalk
eb terminate poll-voting-backend

# Delete RDS
# Go to RDS → Delete database → Skip final snapshot

# Delete S3 bucket
aws s3 rb s3://poll-voting-frontend --force

# Delete CloudFront distribution
# Go to CloudFront → Disable → Delete
```

---

## Summary

Your application will be accessible at:

- **Frontend**: http://poll-voting-frontend.s3-website-us-east-1.amazonaws.com
- **Frontend (CDN)**: https://d1234567890abc.cloudfront.net
- **Backend**: http://poll-voting-backend.us-east-1.elasticbeanstalk.com
- **Database**: votingapp-db.xxxxxxxxx.us-east-1.rds.amazonaws.com:3306

---

## Cost Estimate (After Free Tier)

| Service | Cost/Month |
|---------|------------|
| RDS db.t3.micro | ~$15 |
| EC2 t2.micro (EB) | ~$8 |
| S3 (5GB) | ~$0.12 |
| CloudFront (1TB) | ~$85 |
| **Total** | **~$108/month** |

**With Free Tier (12 months)**: $0/month

---

## Support

For issues:
1. Check AWS Documentation
2. View CloudWatch Logs
3. Check Elastic Beanstalk Health Dashboard
4. Review RDS Performance Insights

---

**Last Updated**: October 2025
