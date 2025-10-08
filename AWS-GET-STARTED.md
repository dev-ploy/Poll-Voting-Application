# 🎯 AWS Deployment - Getting Started

## Your Poll Voting Application is Ready for AWS Deployment! 🚀

All configuration files and documentation have been created. Follow these steps to deploy.

---

## 📋 Quick Start (Choose Your Path)

### Path 1: 🏃 Fast Track (30 minutes)
**Best for**: Quick deployment, learning AWS basics

👉 **Read**: [`AWS-QUICKSTART.md`](AWS-QUICKSTART.md)

### Path 2: 📚 Complete Guide (1-2 hours)
**Best for**: Production deployment, understanding every step

👉 **Read**: [`AWS-DEPLOYMENT-GUIDE.md`](AWS-DEPLOYMENT-GUIDE.md)

### Path 3: 🤖 Automated (After initial setup)
**Best for**: Redeployments, CI/CD

👉 **Run**: `.\deploy-aws.ps1`

---

## 🎯 What You'll Deploy

```
┌─────────────────────────────────────┐
│     Frontend (Angular)              │
│     S3 Static Website               │
│     + CloudFront CDN (optional)     │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│     Backend (Spring Boot)           │
│     Elastic Beanstalk + EC2         │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│     Database (MySQL)                │
│     Amazon RDS                      │
└─────────────────────────────────────┘
```

---

## 💡 Before You Start

### 1️⃣ Create AWS Account
- Go to https://aws.amazon.com
- Click "Create an AWS Account"
- **Note**: Requires credit card but we use FREE TIER

### 2️⃣ Install Required Tools
```powershell
# Run this script to install AWS CLI and EB CLI
.\setup-aws-tools.ps1
```

### 3️⃣ Get AWS Credentials
1. AWS Console → IAM → Users → Your User
2. Security credentials → Create access key
3. Choose "Command Line Interface (CLI)"
4. Save: Access Key ID and Secret Access Key

### 4️⃣ Configure AWS
```powershell
aws configure

# Enter:
# AWS Access Key ID: [your key]
# AWS Secret Access Key: [your secret]
# Default region: us-east-1
# Default output: json
```

---

## 🚀 Deployment Steps Overview

### Step 1: Database (10 min)
```
AWS Console → RDS → Create Database
- MySQL 8.0
- Free Tier
- Name: votingapp-db
```

### Step 2: Backend (10 min)
```powershell
eb init
eb create poll-voting-backend
eb setenv DATABASE_URL=jdbc:mysql://... DB_USERNAME=admin DB_PASSWORD=...
eb deploy
```

### Step 3: Frontend (5 min)
```powershell
npm run build:prod
aws s3 mb s3://poll-voting-frontend
aws s3 sync dist/poll-app/browser/ s3://poll-voting-frontend/ --acl public-read
```

### Step 4: Connect (2 min)
```powershell
eb setenv CORS_ORIGINS="http://poll-voting-frontend.s3-website-us-east-1.amazonaws.com"
```

---

## 📚 Documentation Files

| File | Purpose | When to Use |
|------|---------|-------------|
| `AWS-QUICKSTART.md` | 30-minute deployment | First time, quick setup |
| `AWS-DEPLOYMENT-GUIDE.md` | Complete guide | Detailed understanding |
| `AWS-DEPLOYMENT-SUMMARY.md` | Overview & reference | Quick lookup |
| `setup-aws-tools.ps1` | Install AWS tools | Initial setup |
| `deploy-aws.ps1` | Automated deployment | Redeployments |

---

## 💰 Cost Estimate

### Free Tier (12 months)
```
✅ RDS MySQL: FREE (750 hours/month)
✅ EC2 Instance: FREE (750 hours/month)
✅ S3 Storage: FREE (5 GB)
✅ Data Transfer: FREE (1 GB)

Total: $0/month
```

### After Free Tier
```
💵 RDS MySQL: ~$15/month
💵 EC2: ~$8/month
💵 S3: ~$0.12/month
💵 CloudFront (optional): ~$85/month

Total: $23-108/month
```

---

## ✅ Deployment Checklist

Print this and check off as you go:

```
Prerequisites:
[ ] AWS account created
[ ] AWS CLI installed (run: aws --version)
[ ] EB CLI installed (run: eb --version)
[ ] AWS credentials configured (run: aws configure)
[ ] Repository cloned locally

Database:
[ ] RDS MySQL instance created
[ ] Security group allows port 3306
[ ] Database credentials saved
[ ] Connection tested

Backend:
[ ] EB initialized (eb init)
[ ] Environment created (eb create)
[ ] Environment variables set (eb setenv)
[ ] JAR built (mvnw clean package)
[ ] Deployed successfully (eb deploy)
[ ] Health check passes

Frontend:
[ ] Production build created (npm run build:prod)
[ ] S3 bucket created
[ ] Files uploaded
[ ] Static hosting enabled
[ ] Site accessible

Final:
[ ] CORS configured
[ ] End-to-end test passed
[ ] URLs documented
```

---

## 🎓 Learning Resources

### AWS Services You'll Use
- **RDS** (Relational Database Service) - MySQL database
- **Elastic Beanstalk** - Backend deployment platform
- **EC2** (Elastic Compute Cloud) - Virtual servers
- **S3** (Simple Storage Service) - Frontend file storage
- **CloudFront** (optional) - Content delivery network

### Video Tutorials (Recommended)
1. AWS Free Tier Overview (15 min)
2. Elastic Beanstalk Java Deployment (20 min)
3. S3 Static Website Hosting (10 min)
4. RDS MySQL Setup (15 min)

---

## 🆘 Need Help?

### Common Issues

**1. "aws: command not found"**
```powershell
# Close and reopen PowerShell after installing AWS CLI
# Or run: .\setup-aws-tools.ps1
```

**2. "EB environment creation failed"**
```powershell
# Check logs
eb logs

# Common fix: Verify IAM permissions
```

**3. "Database connection refused"**
```powershell
# Check RDS security group allows port 3306
# Verify DATABASE_URL format: jdbc:mysql://host:3306/database
```

**4. "S3 access denied"**
```powershell
# Ensure bucket policy allows public read
# Check "Block all public access" is OFF
```

### Get Support
- Check the troubleshooting section in `AWS-DEPLOYMENT-GUIDE.md`
- View AWS CloudWatch logs
- Run: `eb logs` for backend logs
- AWS Free Tier Forum: https://forums.aws.amazon.com

---

## 🎯 Next Steps After Reading This

1. **If you want quick deployment**:
   - Open `AWS-QUICKSTART.md`
   - Follow the 6 quick steps
   - Deploy in 30 minutes

2. **If you want detailed understanding**:
   - Open `AWS-DEPLOYMENT-GUIDE.md`
   - Read through each section
   - Follow comprehensive instructions

3. **If you need reference**:
   - Keep `AWS-DEPLOYMENT-SUMMARY.md` handy
   - Use for quick command lookups
   - Check architecture diagrams

---

## 🎉 You're Ready!

Everything is set up for AWS deployment:
- ✅ Configuration files created
- ✅ Deployment scripts ready
- ✅ Documentation complete
- ✅ Free tier optimized

**Choose your guide and start deploying!** 🚀

---

## 📞 Quick Links

- 🏠 [GitHub Repository](https://github.com/dev-ploy/Poll-Voting-Application)
- 📖 [Quick Start Guide](AWS-QUICKSTART.md)
- 📚 [Complete Deployment Guide](AWS-DEPLOYMENT-GUIDE.md)
- 📋 [Deployment Summary](AWS-DEPLOYMENT-SUMMARY.md)
- 🔧 [Setup Script](setup-aws-tools.ps1)
- 🤖 [Deploy Script](deploy-aws.ps1)

---

*Ready to deploy? Open [`AWS-QUICKSTART.md`](AWS-QUICKSTART.md) and let's go! 🚀*
