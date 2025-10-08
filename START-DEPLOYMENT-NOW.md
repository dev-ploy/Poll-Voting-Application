# 🚀 START HERE: AWS Free Deployment - Quick Steps

## ⚡ Your Mission: Deploy Everything on AWS for FREE

**Time Required:** 45 minutes  
**Cost:** $0 (Free for 12 months with AWS Free Tier)

---

## 📍 WHERE YOU ARE NOW

✅ Repository ready at: `E:\Voting-App`  
✅ AWS CLI installing...  
⏳ Ready to deploy!

---

## 🎯 STEP 1: Complete AWS CLI Setup (5 minutes)

### Option A: Wait for Installation to Complete

The AWS CLI is currently installing. **Close this PowerShell window and open a NEW one** in 2-3 minutes, then run:

```powershell
aws --version
```

If you see version info, you're good! Skip to **Step 1.2**.

### Option B: Manual Installation (if above fails)

1. Download: https://awscli.amazonaws.com/AWSCLIV2.msi
2. Run the installer
3. Click "Next" → "Next" → "Install"
4. Close and reopen PowerShell
5. Run: `aws --version`

### Step 1.2: Get AWS Access Keys

**Do this NOW while waiting:**

1. Open: https://console.aws.amazon.com
2. Sign in to your AWS account
3. Click your name (top right) → **"Security credentials"**
4. Scroll to **"Access keys"**
5. Click **"Create access key"**
6. Select: **"Command Line Interface (CLI)"**
7. Check the box → Click **"Next"** → **"Create access key"**
8. **📝 SAVE THESE IMMEDIATELY:**
   ```
   Access Key ID: AKIA________________
   Secret Access Key: ________________________________________
   ```
   **⚠️ You'll never see the secret again!**

### Step 1.3: Configure AWS CLI

In PowerShell:
```powershell
aws configure
```

Enter:
```
AWS Access Key ID: [paste your key]
AWS Secret Access Key: [paste your secret]
Default region name: us-east-1
Default output format: json
```

**Test it:**
```powershell
aws sts get-caller-identity
```

✅ If you see your AWS account info → **SUCCESS!**

---

## 🗄️ STEP 2: Create MySQL Database (15 minutes)

### Use AWS Console (Easier for First Time)

1. **Open:** https://console.aws.amazon.com/rds
2. Click: **"Create database"** (orange button)
3. **Choose:** Standard create
4. **Engine:** MySQL 8.0.35
5. **Templates:** ✅ **Free tier** (IMPORTANT!)
6. **Settings:**
   ```
   DB instance identifier: votingapp-db
   Master username: admin
   Master password: [Choose strong password - WRITE IT DOWN!]
   ```
   
   **📝 Save this:**
   ```
   Username: admin
   Password: _______________________
   ```

7. **Instance:** Should auto-select `db.t3.micro` ✅
8. **Storage:** 20 GB (default is fine)
9. **Connectivity:**
   - Public access: **YES** ✅ (Important!)
   - VPC security group: **Create new**
   - Name: `votingapp-db-sg`

10. **Additional config:**
    - Initial database name: `votingapp`
    - ✅ Enable automated backups

11. Click: **"Create database"**
12. **⏳ Wait 5-10 minutes** (grab coffee ☕)

### Configure Access (CRITICAL!)

After database is "Available":

1. Click on `votingapp-db`
2. In **"Connectivity & security"** tab, click the security group link
3. Click **"Edit inbound rules"**
4. Click **"Add rule"**
5. Choose:
   ```
   Type: MySQL/Aurora
   Source: Anywhere-IPv4 (0.0.0.0/0)
   ```
6. Click **"Save rules"**

### Get Connection Info

Back in RDS → `votingapp-db`:

**Copy the Endpoint** (looks like):
```
votingapp-db.xxxxxxxxxxxxx.us-east-1.rds.amazonaws.com
```

**📝 Save your connection string:**
```
jdbc:mysql://votingapp-db.xxxxxxxxxxxxx.us-east-1.rds.amazonaws.com:3306/votingapp
```

---

## 🖥️ STEP 3: Deploy Backend (15 minutes)

### Step 3.1: Install EB CLI

```powershell
pip install awsebcli --upgrade --user
```

**If pip not found:** Install Python from https://www.python.org/downloads/

Then close/reopen PowerShell and try again.

**Verify:**
```powershell
eb --version
```

### Step 3.2: Build Backend

```powershell
cd E:\Voting-App\backend\votingapp
.\mvnw.cmd clean package -DskipTests
```

⏳ Wait 2-3 minutes for build.

### Step 3.3: Initialize Elastic Beanstalk

```powershell
cd E:\Voting-App
eb init
```

**Answers:**
- Region: `1` (us-east-1)
- Application name: `poll-voting-app`
- Platform: Java / Corretto 17
- CodeCommit: `n`
- SSH: `y`

### Step 3.4: Create Environment

```powershell
eb create poll-voting-backend
```

**Answers:**
- Environment name: `poll-voting-backend`
- DNS CNAME: `poll-voting-backend`
- Load balancer: `application`

⏳ **Wait 5-10 minutes** ☕

### Step 3.5: Configure Environment

**Replace with YOUR values:**

```powershell
eb setenv `
  SERVER_PORT=8080 `
  SPRING_PROFILES_ACTIVE=production `
  DATABASE_URL="jdbc:mysql://YOUR-RDS-ENDPOINT:3306/votingapp" `
  DB_USERNAME=admin `
  DB_PASSWORD="YOUR-PASSWORD" `
  CORS_ORIGINS="*"
```

### Step 3.6: Deploy

```powershell
eb deploy
```

⏳ Wait 3-5 minutes.

### Step 3.7: Get Backend URL

```powershell
eb status
```

Look for: `CNAME: poll-voting-backend.us-east-1.elasticbeanstalk.com`

**Test it:**
```powershell
curl http://poll-voting-backend.us-east-1.elasticbeanstalk.com/api/polls
```

Expected: `[]` (empty array)

✅ **Backend is LIVE!**

---

## 🌐 STEP 4: Deploy Frontend (10 minutes)

### Step 4.1: Update Environment

**Edit:** `E:\Voting-App\frontend\poll-app\src\environments\environment.prod.ts`

```typescript
export const environment = {
  production: true,
  apiUrl: 'http://poll-voting-backend.us-east-1.elasticbeanstalk.com'
};
```

**Replace** with YOUR backend URL!

### Step 4.2: Build Frontend

```powershell
cd E:\Voting-App\frontend\poll-app
npm install
npm run build:prod
```

⏳ Wait 2-3 minutes.

### Step 4.3: Create S3 Bucket

**Choose a unique name** (replace `yourname`):

```powershell
$BUCKET="poll-voting-frontend-yourname"
aws s3 mb s3://$BUCKET --region us-east-1
aws s3 website s3://$BUCKET/ --index-document index.html --error-document index.html
```

### Step 4.4: Make Bucket Public

```powershell
# Disable block public access
aws s3api put-public-access-block --bucket $BUCKET --public-access-block-configuration "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"

# Create policy file
@"
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "PublicReadGetObject",
    "Effect": "Allow",
    "Principal": "*",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::$BUCKET/*"
  }]
}
"@ | Out-File -FilePath "policy.json" -Encoding utf8

# Apply policy
aws s3api put-bucket-policy --bucket $BUCKET --policy file://policy.json
```

### Step 4.5: Upload Files

```powershell
aws s3 sync dist/poll-app/browser/ s3://$BUCKET/ --acl public-read
```

### Step 4.6: Get Frontend URL

Your app is live at:
```
http://poll-voting-frontend-yourname.s3-website-us-east-1.amazonaws.com
```

**Open it in your browser!** 🎉

### Step 4.7: Update CORS

```powershell
cd E:\Voting-App
eb setenv CORS_ORIGINS="http://poll-voting-frontend-yourname.s3-website-us-east-1.amazonaws.com"
```

---

## 🎉 YOU'RE DONE!

### Your Live Application:

```
Frontend: http://poll-voting-frontend-yourname.s3-website-us-east-1.amazonaws.com
Backend:  http://poll-voting-backend.us-east-1.elasticbeanstalk.com
Database: votingapp-db.xxxxx.us-east-1.rds.amazonaws.com
```

### Test It:

1. Open frontend URL
2. Create a poll
3. Vote on it
4. See results!

---

## 🔧 Quick Commands

```powershell
# View logs
eb logs

# Redeploy backend
eb deploy

# Update frontend
cd E:\Voting-App\frontend\poll-app
npm run build:prod
aws s3 sync dist/poll-app/browser/ s3://$BUCKET/ --delete --acl public-read
```

---

## 🆘 Troubleshooting

### Backend Not Starting?
```powershell
eb logs
```
Check for database connection errors.

### CORS Errors?
Make sure CORS_ORIGINS matches your frontend URL exactly.

### Can't Connect to Database?
- Check RDS security group allows port 3306
- Verify DATABASE_URL is correct
- Check DB_PASSWORD has no typos

---

## 💰 Cost: $0 for 12 Months!

AWS Free Tier includes:
- ✅ RDS MySQL: 750 hours/month
- ✅ EC2: 750 hours/month  
- ✅ S3: 5 GB storage
- ✅ Data transfer: 1 GB/month

**Set billing alerts:** https://console.aws.amazon.com/billing/

---

## 📚 Full Documentation

For more details, see:
- `AWS-FREE-DEPLOYMENT-WALKTHROUGH.md` (complete guide)
- `AWS-DEPLOYMENT-GUIDE.md` (advanced)
- `AWS-QUICKSTART.md` (30-minute version)

---

**🚀 START NOW! Follow Step 1 above.**

Good luck! 🎉
