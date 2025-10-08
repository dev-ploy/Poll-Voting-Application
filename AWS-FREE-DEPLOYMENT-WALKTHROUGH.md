# 🚀 AWS Free Tier Deployment - Step-by-Step Guide
# Poll Voting Application - Complete Deployment

## ✅ What You'll Deploy (ALL FREE for 12 months)

1. **MySQL Database** → Amazon RDS (FREE: 750 hours/month)
2. **Spring Boot Backend** → Elastic Beanstalk + EC2 (FREE: 750 hours/month)
3. **Angular Frontend** → Amazon S3 + CloudFront (FREE: 5GB storage)

**Total Cost: $0/month for 12 months** 🎉

---

## 📋 Prerequisites Checklist

Before starting, ensure you have:

- [ ] AWS Account created at https://aws.amazon.com
- [ ] Credit card added to AWS (required for verification, won't be charged)
- [ ] AWS CLI installed (just installed!)
- [ ] This terminal open
- [ ] 30-45 minutes of time

---

## 🎯 PART 1: Setup AWS CLI (5 minutes)

### Step 1.1: Verify AWS CLI Installation

Close and reopen PowerShell, then run:
```powershell
aws --version
```

**Expected output:** `aws-cli/2.x.x Python/3.x.x Windows/...`

### Step 1.2: Get AWS Access Keys

1. Go to: https://console.aws.amazon.com
2. Sign in to your AWS account
3. Click your username (top right) → **Security credentials**
4. Scroll to **Access keys** section
5. Click **"Create access key"**
6. Choose **"Command Line Interface (CLI)"**
7. Check the confirmation box
8. Click **"Next"** → **"Create access key"**
8. **IMPORTANT:** Copy both:
   - **Access key ID** (starts with AKIA...)
   - **Secret access key** (long random string)
   
   ⚠️ Save these somewhere safe! You won't see the secret again.

### Step 1.3: Configure AWS CLI

Run this command in PowerShell:
```powershell
aws configure
```

Enter when prompted:
```
AWS Access Key ID: [paste your access key]
AWS Secret Access Key: [paste your secret key]
Default region name: us-east-1
Default output format: json
```

### Step 1.4: Verify Configuration

```powershell
aws sts get-caller-identity
```

**Expected output:** Your AWS account details in JSON format.

✅ **If you see your account info, AWS CLI is configured!**

---

## 🗄️ PART 2: Deploy MySQL Database (RDS) - 15 minutes

### Step 2.1: Create RDS MySQL Instance via AWS Console

**Why Console?** It's more visual and easier for first-time setup.

1. **Open AWS Console**: https://console.aws.amazon.com
2. **Navigate to RDS**:
   - Search "RDS" in the top search bar
   - Click **"RDS"** service

3. **Create Database**:
   - Click orange **"Create database"** button

4. **Choose Database Creation Method**:
   - Select: **Standard create**

5. **Engine Options**:
   ```
   Engine type: MySQL
   Edition: MySQL Community
   Version: MySQL 8.0.35 (or latest 8.0.x)
   ```

6. **Templates**:
   - Select: ✅ **Free tier**

7. **Settings**:
   ```
   DB instance identifier: votingapp-db
   Master username: admin
   Master password: [Create a strong password]
   Confirm password: [Same password]
   ```
   
   📝 **IMPORTANT:** Write down your password! You'll need it later.
   ```
   Username: admin
   Password: ____________________
   ```

8. **DB Instance Class**:
   - Should auto-select: **db.t3.micro** (Free tier eligible ✅)

9. **Storage**:
   ```
   Storage type: General Purpose SSD (gp2)
   Allocated storage: 20 GB
   ✅ Enable storage autoscaling
   Maximum storage threshold: 100 GB
   ```

10. **Connectivity**:
    ```
    Virtual private cloud (VPC): Default VPC
    Public access: ✅ Yes (important for initial setup)
    VPC security group: ● Create new
    New VPC security group name: votingapp-db-sg
    Availability Zone: No preference
    ```

11. **Database Authentication**:
    - Select: **Password authentication**

12. **Additional Configuration** (Click to expand):
    ```
    Initial database name: votingapp
    ✅ Enable automated backups
    Backup retention period: 7 days
    Backup window: No preference
    
    ⬜ Enable encryption (not needed for free tier)
    ✅ Enable Enhanced monitoring (optional)
    ⬜ Enable deletion protection (disable for easier testing)
    ```

13. **Review & Create**:
    - Scroll down and click **"Create database"**

14. **Wait for Creation** (5-10 minutes):
    - Status will show "Creating..."
    - Refresh the page periodically
    - When ready, status will show "Available" ✅

### Step 2.2: Configure Security Group (Allow Connections)

**Important:** By default, RDS doesn't allow external connections. We need to fix this.

1. **In RDS Dashboard**, click on your database: **votingapp-db**

2. **Find Security Groups**:
   - Scroll to **"Connectivity & security"** tab
   - Under **"Security"**, click the security group link (e.g., `votingapp-db-sg`)

3. **Edit Inbound Rules**:
   - You'll be redirected to EC2 Security Groups
   - Click **"Edit inbound rules"**
   - Click **"Add rule"**
   - Configure:
     ```
     Type: MySQL/Aurora (Port 3306 will auto-fill)
     Source: Anywhere-IPv4 (0.0.0.0/0)
     Description: Allow MySQL connections
     ```
   
   ⚠️ **Note:** For production, you'd restrict this to specific IPs. For testing, this is fine.

4. **Save Rules**:
   - Click **"Save rules"**

### Step 2.3: Get RDS Connection Details

1. **Go back to RDS** → **Databases** → **votingapp-db**

2. **Copy the Endpoint**:
   - Under **"Connectivity & security"** tab
   - Find **"Endpoint"** (looks like: `votingapp-db.xxxxx.us-east-1.rds.amazonaws.com`)
   - Copy this entire endpoint

3. **Save Your Connection Details**:
   ```
   Endpoint: votingapp-db.xxxxx.us-east-1.rds.amazonaws.com
   Port: 3306
   Database: votingapp
   Username: admin
   Password: [your password from Step 2.1.7]
   ```

   Full connection string:
   ```
   jdbc:mysql://votingapp-db.xxxxx.us-east-1.rds.amazonaws.com:3306/votingapp
   ```

### Step 2.4: Test Database Connection (Optional but Recommended)

If you have MySQL client installed:
```powershell
mysql -h votingapp-db.xxxxx.us-east-1.rds.amazonaws.com -P 3306 -u admin -p
# Enter password when prompted
```

If successful, you'll see MySQL prompt. Type `exit` to quit.

✅ **Database is ready!**

---

## 🖥️ PART 3: Deploy Backend (Elastic Beanstalk) - 15 minutes

### Step 3.1: Install Elastic Beanstalk CLI

```powershell
pip install awsebcli --upgrade --user
```

**If pip is not found**, install Python first:
1. Download from: https://www.python.org/downloads/
2. Install Python 3.11+ (check "Add to PATH")
3. Close and reopen PowerShell
4. Run the pip command again

### Step 3.2: Verify EB CLI Installation

Close and reopen PowerShell, then:
```powershell
eb --version
```

**Expected output:** `EB CLI 3.x.x (Python 3.x.x)`

### Step 3.3: Build Backend JAR

```powershell
cd E:\Voting-App\backend\votingapp

# Make mvnw executable (if needed)
# For Windows, just run:
.\mvnw.cmd clean package -DskipTests
```

Wait for build to complete (2-3 minutes).

**Expected output:** `BUILD SUCCESS`

### Step 3.4: Initialize Elastic Beanstalk

```powershell
cd E:\Voting-App

# Initialize EB in your project
eb init
```

**Follow the prompts:**

```
Select a default region: 
1) us-east-1
[Select 1]

Enter Application Name: poll-voting-app
[Press Enter]

It appears you are using Java. Is this correct?
[Type: y and press Enter]

Select a platform branch:
[Choose: Corretto 17 running on 64bit Amazon Linux 2]

Do you wish to continue with CodeCommit?
[Type: n and press Enter]

Do you want to set up SSH for your instances?
[Type: y and press Enter]

Select a keypair:
[Choose: Create new KeyPair]

Enter a name for your keypair: votingapp-key
[Press Enter]
```

✅ **Elastic Beanstalk initialized!**

### Step 3.5: Create EB Environment

```powershell
eb create poll-voting-backend
```

**Follow the prompts:**
```
Enter Environment Name: poll-voting-backend
[Press Enter]

Enter DNS CNAME prefix: poll-voting-backend
[Press Enter]

Select a load balancer type:
[Choose: application]
```

⏱️ **This will take 5-10 minutes.** EB is creating:
- EC2 instance
- Load balancer
- Security groups
- Auto-scaling configuration

**Wait for:** `Successfully launched environment: poll-voting-backend`

### Step 3.6: Set Environment Variables

Replace the RDS endpoint and password with YOUR values:

```powershell
eb setenv `
  SERVER_PORT=8080 `
  SPRING_PROFILES_ACTIVE=production `
  DATABASE_URL="jdbc:mysql://votingapp-db.xxxxx.us-east-1.rds.amazonaws.com:3306/votingapp" `
  DB_USERNAME=admin `
  DB_PASSWORD="your-password-here" `
  CORS_ORIGINS="*"
```

⚠️ Replace:
- `votingapp-db.xxxxx.us-east-1.rds.amazonaws.com` with your actual RDS endpoint
- `your-password-here` with your actual RDS password

**This will trigger an environment update (2-3 minutes).**

### Step 3.7: Deploy Backend Application

```powershell
# Make sure you're in the root directory
cd E:\Voting-App

# Deploy
eb deploy
```

⏱️ **Wait 3-5 minutes** for deployment.

### Step 3.8: Get Backend URL

```powershell
eb status
```

Look for the line:
```
CNAME: poll-voting-backend.us-east-1.elasticbeanstalk.com
```

Copy this URL. Your backend is at:
```
http://poll-voting-backend.us-east-1.elasticbeanstalk.com
```

### Step 3.9: Test Backend

Open in browser or use curl:
```powershell
# Test health endpoint
curl http://poll-voting-backend.us-east-1.elasticbeanstalk.com/actuator/health

# Test API
curl http://poll-voting-backend.us-east-1.elasticbeanstalk.com/api/polls
```

**Expected:** JSON response with empty array `[]` (no polls yet)

✅ **Backend is live!**

---

## 🌐 PART 4: Deploy Frontend (S3 + CloudFront) - 10 minutes

### Step 4.1: Update Frontend Environment

First, update the frontend to point to your backend:

**Edit:** `E:\Voting-App\frontend\poll-app\src\environments\environment.prod.ts`

Replace with YOUR backend URL:
```typescript
export const environment = {
  production: true,
  apiUrl: 'http://poll-voting-backend.us-east-1.elasticbeanstalk.com'
};
```

Save the file.

### Step 4.2: Build Frontend

```powershell
cd E:\Voting-App\frontend\poll-app

# Install dependencies (if not already done)
npm install

# Build for production
npm run build:prod
```

⏱️ **Wait 2-3 minutes** for build.

**Expected output:** Files created in `dist/poll-app/browser/`

### Step 4.3: Create S3 Bucket

Choose a **globally unique** bucket name (replace `yourname` with your name/username):

```powershell
$BUCKET_NAME = "poll-voting-frontend-yourname"

# Create bucket
aws s3 mb s3://$BUCKET_NAME --region us-east-1
```

**Expected output:** `make_bucket: poll-voting-frontend-yourname`

### Step 4.4: Configure Bucket for Static Website Hosting

```powershell
# Enable static website hosting
aws s3 website s3://$BUCKET_NAME/ --index-document index.html --error-document index.html
```

### Step 4.5: Set Bucket Policy (Make Public)

Create a policy file:

```powershell
@"
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::$BUCKET_NAME/*"
    }
  ]
}
"@ | Out-File -FilePath "bucket-policy.json" -Encoding utf8
```

Apply the policy:

```powershell
aws s3api put-bucket-policy --bucket $BUCKET_NAME --policy file://bucket-policy.json
```

### Step 4.6: Disable Block Public Access

```powershell
aws s3api put-public-access-block --bucket $BUCKET_NAME --public-access-block-configuration "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"
```

### Step 4.7: Upload Frontend Files

```powershell
aws s3 sync dist/poll-app/browser/ s3://$BUCKET_NAME/ --acl public-read
```

⏱️ **Wait 1-2 minutes** for upload.

**Expected output:** List of uploaded files

### Step 4.8: Get Frontend URL

Your frontend is now live at:
```
http://poll-voting-frontend-yourname.s3-website-us-east-1.amazonaws.com
```

Open this URL in your browser!

### Step 4.9: Update Backend CORS

Now update the backend to allow your frontend URL:

```powershell
cd E:\Voting-App

eb setenv CORS_ORIGINS="http://poll-voting-frontend-yourname.s3-website-us-east-1.amazonaws.com"
```

⏱️ **Wait 2-3 minutes** for environment update.

✅ **Frontend is live!**

---

## 🎉 PART 5: Test Your Application

### Step 5.1: Access Your Application

Open in browser:
```
http://poll-voting-frontend-yourname.s3-website-us-east-1.amazonaws.com
```

### Step 5.2: Create a Poll

1. Click "Create Poll" (or similar button)
2. Enter poll question and options
3. Submit the poll
4. Vote on the poll
5. See results update

### Step 5.3: Verify Backend

Check backend API directly:
```
http://poll-voting-backend.us-east-1.elasticbeanstalk.com/api/polls
```

You should see your created poll in JSON format.

---

## 📊 Your Deployed Application

### URLs
```
Frontend:  http://poll-voting-frontend-yourname.s3-website-us-east-1.amazonaws.com
Backend:   http://poll-voting-backend.us-east-1.elasticbeanstalk.com
Database:  votingapp-db.xxxxx.us-east-1.rds.amazonaws.com:3306
```

### Architecture
```
User Browser
     ↓
S3 Static Website (Angular)
     ↓
Elastic Beanstalk (Spring Boot)
     ↓
RDS MySQL Database
```

---

## 🔧 Useful Commands

### View Backend Logs
```powershell
eb logs
```

### View Backend Status
```powershell
eb status
```

### Open Backend in Browser
```powershell
eb open
```

### SSH to Backend Instance
```powershell
eb ssh
```

### Update Backend Environment Variables
```powershell
eb setenv KEY=value
```

### Redeploy Backend
```powershell
eb deploy
```

### Update Frontend
```powershell
# After making changes and rebuilding:
cd E:\Voting-App\frontend\poll-app
npm run build:prod
aws s3 sync dist/poll-app/browser/ s3://poll-voting-frontend-yourname/ --delete --acl public-read
```

---

## 🆘 Troubleshooting

### Backend Not Starting
```powershell
# Check logs
eb logs

# Common issues:
# 1. Wrong DATABASE_URL format
# 2. Incorrect DB_PASSWORD
# 3. Security group not allowing connections
```

### CORS Errors
```powershell
# Update CORS_ORIGINS to match your frontend URL exactly
eb setenv CORS_ORIGINS="http://your-exact-frontend-url"
```

### Database Connection Failed
```powershell
# Verify security group allows port 3306
# Check RDS is "Available"
# Verify endpoint and credentials are correct
```

### Frontend Not Loading
```powershell
# Check if bucket policy is public
# Verify static website hosting is enabled
# Check browser console for errors (F12)
```

---

## 💰 Cost Monitoring

### Check AWS Free Tier Usage
1. Go to: https://console.aws.amazon.com/billing/
2. Click "Free Tier" in left menu
3. Monitor your usage

### Set Up Billing Alerts
1. Go to: https://console.aws.amazon.com/billing/
2. Click "Billing preferences"
3. Enable "Receive Free Tier Usage Alerts"
4. Enter your email

---

## 🧹 Cleanup (When You're Done Testing)

To avoid any charges after free tier expires:

### Delete Frontend
```powershell
# Empty and delete S3 bucket
aws s3 rm s3://poll-voting-frontend-yourname --recursive
aws s3 rb s3://poll-voting-frontend-yourname
```

### Delete Backend
```powershell
eb terminate poll-voting-backend
```

### Delete Database
1. Go to RDS Console
2. Select `votingapp-db`
3. Actions → Delete
4. Uncheck "Create final snapshot"
5. Check acknowledgment
6. Type "delete me"
7. Click "Delete"

---

## 🎓 What You've Learned

✅ AWS RDS for managed MySQL databases
✅ Elastic Beanstalk for Java backend deployment
✅ S3 for static website hosting
✅ AWS CLI and EB CLI usage
✅ Environment variable configuration
✅ Security group configuration
✅ Full-stack application deployment on AWS

---

## 📞 Need Help?

- AWS Documentation: https://docs.aws.amazon.com
- AWS Free Tier: https://aws.amazon.com/free
- EB CLI Docs: https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3.html

---

**🎉 Congratulations! Your application is now live on AWS!**

**Frontend:** http://poll-voting-frontend-yourname.s3-website-us-east-1.amazonaws.com
**Backend:** http://poll-voting-backend.us-east-1.elasticbeanstalk.com

---

*Save this file for future reference!*
