# AWS Deployment - Quick Start Guide

## 🚀 Deploy Poll Voting Application to AWS in 30 Minutes

### Prerequisites
- AWS Account (free tier)
- Git installed
- Maven installed
- Node.js installed

---

## Quick Steps

### 1. Install AWS Tools (5 minutes)

```powershell
# Run the setup script
.\setup-aws-tools.ps1

# Close and reopen PowerShell, then verify
aws --version
eb --version
```

### 2. Configure AWS Credentials (2 minutes)

```powershell
aws configure
```

Enter your:
- AWS Access Key ID
- AWS Secret Access Key
- Region: `us-east-1`
- Output format: `json`

**Get AWS Credentials:**
1. Go to AWS Console → IAM
2. Users → Your user → Security credentials
3. Create access key → Command Line Interface (CLI)

### 3. Create MySQL Database (10 minutes)

**Via AWS Console:**
1. Go to RDS service
2. Create database
3. Choose:
   - Engine: MySQL 8.0
   - Template: Free tier
   - DB instance: `votingapp-db`
   - Master username: `admin`
   - Master password: [your password]
   - Initial database: `votingapp`
4. Click "Create database"
5. Wait 5-10 minutes
6. Copy the **Endpoint** (e.g., `votingapp-db.xxx.us-east-1.rds.amazonaws.com`)

**Configure Security Group:**
1. EC2 → Security Groups → `votingapp-db-sg`
2. Edit inbound rules
3. Add: MySQL/Aurora (3306) from Anywhere (0.0.0.0/0)

### 4. Deploy Backend (10 minutes)

```powershell
cd E:\Voting-App

# Initialize Elastic Beanstalk
eb init

# Prompts:
# Region: us-east-1
# Application: poll-voting-app
# Platform: Java (Corretto 17)
# SSH: Yes

# Create environment
eb create poll-voting-backend

# Set environment variables (replace with your RDS endpoint & password)
eb setenv `
  SERVER_PORT=8080 `
  SPRING_PROFILES_ACTIVE=production `
  DATABASE_URL="jdbc:mysql://votingapp-db.xxx.us-east-1.rds.amazonaws.com:3306/votingapp" `
  DB_USERNAME=admin `
  DB_PASSWORD="your-password"

# Build and deploy
cd backend\votingapp
.\mvnw.cmd clean package -DskipTests
cd ..\..
eb deploy
```

### 5. Deploy Frontend (5 minutes)

**Update frontend config:**

Edit `frontend\poll-app\src\environments\environment.prod.ts`:
```typescript
export const environment = {
  production: true,
  apiUrl: 'http://poll-voting-backend.us-east-1.elasticbeanstalk.com'
};
```

**Build & Deploy:**

```powershell
# Build frontend
cd frontend\poll-app
npm install
npm run build:prod

# Create S3 bucket (choose unique name)
aws s3 mb s3://poll-voting-frontend-yourname --region us-east-1

# Upload files
aws s3 sync dist/poll-app/browser/ s3://poll-voting-frontend-yourname/ --acl public-read

# Enable static website hosting
aws s3 website s3://poll-voting-frontend-yourname/ --index-document index.html --error-document index.html
```

**Or use AWS Console:**
1. S3 → Create bucket → `poll-voting-frontend-yourname`
2. Uncheck "Block all public access"
3. Upload files from `dist/poll-app/browser/`
4. Properties → Static website hosting → Enable
5. Permissions → Bucket policy → Add public read policy

### 6. Update CORS (2 minutes)

```powershell
eb setenv CORS_ORIGINS="http://poll-voting-frontend-yourname.s3-website-us-east-1.amazonaws.com"
```

---

## Access Your Application

**Frontend:**
```
http://poll-voting-frontend-yourname.s3-website-us-east-1.amazonaws.com
```

**Backend:**
```
http://poll-voting-backend.us-east-1.elasticbeanstalk.com
```

**Test Backend:**
```
http://poll-voting-backend.us-east-1.elasticbeanstalk.com/actuator/health
```

---

## Automated Deployment

After initial setup, use the automated script:

```powershell
.\deploy-aws.ps1
```

This script will:
1. Build backend
2. Build frontend
3. Deploy to Elastic Beanstalk
4. Upload to S3
5. Show deployment URLs

---

## Common Issues

### Backend won't start
```powershell
# Check logs
eb logs

# Common fixes:
# 1. Verify DATABASE_URL is correct
# 2. Check DB_PASSWORD has no special chars that need escaping
# 3. Ensure RDS security group allows port 3306
```

### CORS Errors
```powershell
# Update CORS to match your frontend URL
eb setenv CORS_ORIGINS="http://your-frontend-url.s3-website-us-east-1.amazonaws.com"
```

### S3 Access Denied
- Ensure bucket policy allows public read
- Check "Block all public access" is off

---

## Cost

**Free Tier (12 months):**
- RDS MySQL: 750 hours/month (t3.micro)
- EC2: 750 hours/month (t2.micro) 
- S3: 5 GB storage
- **Total: $0/month**

**After Free Tier:**
- ~$15-25/month for basic usage

---

## Cleanup

To avoid charges:

```powershell
# Delete Elastic Beanstalk
eb terminate poll-voting-backend

# Delete S3 bucket
aws s3 rb s3://poll-voting-frontend-yourname --force

# Delete RDS (via AWS Console)
# RDS → Databases → Delete → Skip final snapshot
```

---

## Next Steps

1. ✅ Setup custom domain (Route 53)
2. ✅ Add HTTPS (CloudFront + ACM)
3. ✅ Setup CI/CD (GitHub Actions)
4. ✅ Enable CloudWatch monitoring
5. ✅ Configure auto-scaling

See full guide: `AWS-DEPLOYMENT-GUIDE.md`

---

## Support

- View logs: `eb logs`
- SSH to instance: `eb ssh`
- Open in browser: `eb open`
- Check status: `eb status`

For detailed instructions, see `AWS-DEPLOYMENT-GUIDE.md`
