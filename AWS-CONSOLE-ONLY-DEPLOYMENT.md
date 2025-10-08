# 🚀 AWS Deployment WITHOUT CLI - Console Only Method

## ✅ Perfect for When AWS CLI Won't Install

**Time:** 45 minutes  
**Cost:** $0 (AWS Free Tier)  
**Requirements:** Just a web browser!

---

## 🎯 WHY THIS METHOD?

AWS CLI installation can be tricky on some systems. This guide uses **AWS Console only** (web interface) - much easier!

---

## 📋 PART 1: Create MySQL Database (RDS) - 15 minutes

### Step 1: Login to AWS

1. Go to: https://console.aws.amazon.com
2. Sign in with your AWS account

### Step 2: Create RDS MySQL Database

1. **Search "RDS"** in the top search bar → Click **RDS**
2. Click **"Databases"** in left menu
3. Click orange **"Create database"** button

### Step 3: Configure Database

**Engine options:**
```
✅ Standard create
Engine type: MySQL
Version: MySQL 8.0.35
Template: ✅ Free tier (IMPORTANT!)
```

**Settings:**
```
DB instance identifier: votingapp-db
Master username: admin
Master password: [Choose a strong password]
Confirm password: [Same password]
```

**📝 WRITE DOWN YOUR PASSWORD:**
```
Username: admin  
Password: _________________________
```

**DB Instance size:**
```
Instance class: db.t3.micro (should be auto-selected ✅)
```

**Storage:**
```
Storage type: General Purpose SSD (gp2)
Allocated storage: 20 GB
✅ Enable storage autoscaling
```

**Connectivity:**
```
VPC: Default VPC
Public access: ✅ YES (IMPORTANT!)
VPC security group: Create new
Name: votingapp-db-sg
```

**Database authentication:**
```
✅ Password authentication
```

**Additional configuration** (expand it):
```
Initial database name: votingapp
✅ Enable automated backups
Backup retention: 7 days
```

4. Click **"Create database"** at the bottom
5. **⏳ Wait 5-10 minutes** (Status: Creating... → Available)

### Step 4: Configure Security Group

Once database is **Available**:

1. Click on **votingapp-db**
2. Go to **"Connectivity & security"** tab
3. Click the **Security group** link (looks like: sg-xxxxx)
4. Click **"Edit inbound rules"**
5. Click **"Add rule"**
6. Configure:
   ```
   Type: MySQL/Aurora
   Port: 3306 (auto-fills)
   Source: Anywhere-IPv4 (0.0.0.0/0)
   Description: Allow MySQL
   ```
7. Click **"Save rules"**

### Step 5: Get Database Endpoint

Back in RDS → Databases → votingapp-db:

1. Copy the **Endpoint** (under Connectivity & security):
   ```
   votingapp-db.xxxxxxxxxxxxx.us-east-1.rds.amazonaws.com
   ```

2. **📝 Save this:**
   ```
   Endpoint: votingapp-db.xxxxxxxxxxxxx.us-east-1.rds.amazonaws.com
   Port: 3306
   Database: votingapp
   Username: admin
   Password: [your password]
   
   Full URL: jdbc:mysql://votingapp-db.xxxxxxxxxxxxx.us-east-1.rds.amazonaws.com:3306/votingapp
   ```

✅ **Database is ready!**

---

## 🖥️ PART 2: Deploy Backend (Elastic Beanstalk) - 20 minutes

### Step 1: Build Backend JAR

**In PowerShell:**
```powershell
cd E:\Voting-App\backend\votingapp
.\mvnw.cmd clean package -DskipTests
```

⏳ Wait 2-3 minutes.

**Verify:** Check that `target\votingapp-0.0.1-SNAPSHOT.jar` exists.

### Step 2: Create Elastic Beanstalk Application

1. **Search "Elastic Beanstalk"** in AWS Console → Click it
2. Click **"Create application"**

**Application information:**
```
Application name: poll-voting-app
Application tags: (leave empty)
```

**Platform:**
```
Platform: Java
Platform branch: Corretto 17 running on 64bit Amazon Linux 2023
Platform version: (use recommended)
```

**Application code:**
```
✅ Upload your code
Source code origin: Local file
Choose file: [Click and browse to E:\Voting-App\backend\votingapp\target\votingapp-0.0.1-SNAPSHOT.jar]
```

**Presets:**
```
✅ Single instance (free tier eligible)
```

3. Click **"Next"**

**Service access:**
```
✅ Create and use new service role
Service role name: aws-elasticbeanstalk-service-role (auto-generated)
EC2 instance profile: 
  - Create new: aws-elasticbeanstalk-ec2-role
```

4. Click **"Next"**

**VPC and networking:**
```
VPC: Default VPC
✅ Public IP address: Activated
Instance subnets: Select at least 2 availability zones
```

5. Click **"Next"**

**Instance traffic and scaling:**
```
Environment type: Single instance
Instance types: t2.micro, t3.micro (free tier)
```

6. Click **"Next"**

**Environment properties** (IMPORTANT!):

Click **"Add environment property"** for each:

```
Property 1:
Name: SERVER_PORT
Value: 5000

Property 2:
Name: SPRING_PROFILES_ACTIVE
Value: production

Property 3:
Name: DATABASE_URL
Value: jdbc:mysql://[YOUR-RDS-ENDPOINT]:3306/votingapp

Property 4:
Name: DB_USERNAME
Value: admin

Property 5:
Name: DB_PASSWORD
Value: [your-database-password]

Property 6:
Name: CORS_ORIGINS
Value: *
```

**⚠️ IMPORTANT:** Replace `[YOUR-RDS-ENDPOINT]` with your actual endpoint from Part 1, Step 5!

7. Click **"Next"** → Review → **"Submit"**

⏳ **Wait 10-15 minutes** for deployment.

### Step 3: Get Backend URL

Once environment is healthy (green checkmark):

1. In Elastic Beanstalk dashboard, click your application
2. Copy the **Domain** URL (looks like):
   ```
   poll-voting-app.us-east-1.elasticbeanstalk.com
   ```

3. **Test it in browser:**
   ```
   http://poll-voting-app.us-east-1.elasticbeanstalk.com/api/polls
   ```
   
   **Expected:** `[]` (empty array)

✅ **Backend is live!**

---

## 🌐 PART 3: Deploy Frontend (S3) - 10 minutes

### Step 1: Update Frontend Config

**Edit:** `E:\Voting-App\frontend\poll-app\src\environments\environment.prod.ts`

Replace with YOUR backend URL:
```typescript
export const environment = {
  production: true,
  apiUrl: 'http://poll-voting-app.us-east-1.elasticbeanstalk.com'
};
```

Save the file.

### Step 2: Build Frontend

**In PowerShell:**
```powershell
cd E:\Voting-App\frontend\poll-app
npm install
npm run build:prod
```

⏳ Wait 2-3 minutes.

**Verify:** Files should be in `dist\poll-app\browser\`

### Step 3: Create S3 Bucket

1. **Search "S3"** in AWS Console → Click it
2. Click **"Create bucket"**

**Bucket settings:**
```
Bucket name: poll-voting-frontend-yourname
(Replace 'yourname' with something unique!)

Region: US East (N. Virginia) us-east-1

Object Ownership: ACLs disabled

Block Public Access:
  ⬜ UNCHECK "Block all public access"
  ✅ Check the warning acknowledgment

Bucket Versioning: Disable
Default encryption: Disable
```

3. Click **"Create bucket"**

### Step 4: Upload Frontend Files

1. Click on your bucket: **poll-voting-frontend-yourname**
2. Click **"Upload"**
3. Click **"Add files"** or **"Add folder"**
4. Browse to: `E:\Voting-App\frontend\poll-app\dist\poll-app\browser`
5. **Select ALL files inside browser folder** (not the folder itself!)
6. Click **"Upload"**

⏳ Wait for upload to complete.

### Step 5: Enable Static Website Hosting

1. In your bucket, go to **"Properties"** tab
2. Scroll to **"Static website hosting"**
3. Click **"Edit"**
4. Configure:
   ```
   Static website hosting: ✅ Enable
   Hosting type: Host a static website
   Index document: index.html
   Error document: index.html
   ```
5. Click **"Save changes"**

6. **Copy the Website endpoint** (at the top):
   ```
   http://poll-voting-frontend-yourname.s3-website-us-east-1.amazonaws.com
   ```

### Step 6: Make Files Public

1. Go to **"Permissions"** tab
2. Scroll to **"Bucket policy"**
3. Click **"Edit"**
4. Paste this policy (replace `YOUR-BUCKET-NAME`):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::YOUR-BUCKET-NAME/*"
    }
  ]
}
```

**Replace** `YOUR-BUCKET-NAME` with your actual bucket name!

5. Click **"Save changes"**

### Step 7: Update Backend CORS

Go back to **Elastic Beanstalk**:

1. Click your application → **poll-voting-app**
2. Click **"Configuration"** in left menu
3. Find **"Software"** → Click **"Edit"**
4. Scroll to **"Environment properties"**
5. Find `CORS_ORIGINS` and update value to:
   ```
   http://poll-voting-frontend-yourname.s3-website-us-east-1.amazonaws.com
   ```
   (Use YOUR actual frontend URL!)

6. Click **"Apply"** at bottom

⏳ Wait 2-3 minutes for update.

### Step 8: Test Your Application!

Open your frontend URL:
```
http://poll-voting-frontend-yourname.s3-website-us-east-1.amazonaws.com
```

**Try:**
1. Create a poll
2. Vote on it
3. See results!

✅ **Frontend is live!**

---

## 🎉 YOU'RE DONE!

### Your Live Application:

```
Frontend: http://poll-voting-frontend-yourname.s3-website-us-east-1.amazonaws.com
Backend:  http://poll-voting-app.us-east-1.elasticbeanstalk.com  
Database: votingapp-db.xxxxx.us-east-1.rds.amazonaws.com
```

### 📝 Save These URLs!

---

## 🔧 Making Updates

### Update Backend:

1. Rebuild JAR:
   ```powershell
   cd E:\Voting-App\backend\votingapp
   .\mvnw.cmd clean package -DskipTests
   ```

2. In Elastic Beanstalk Console:
   - Go to your application
   - Click **"Upload and deploy"**
   - Choose the new JAR file
   - Click **"Deploy"**

### Update Frontend:

1. Rebuild:
   ```powershell
   cd E:\Voting-App\frontend\poll-app
   npm run build:prod
   ```

2. In S3 Console:
   - Go to your bucket
   - **Delete old files** (select all → Actions → Delete)
   - **Upload new files** from `dist\poll-app\browser\`

---

## 🆘 Troubleshooting

### Backend shows 502/503 error:
- Check Elastic Beanstalk **Health** page
- Click **"Logs"** → **"Request logs"** → **"Last 100 lines"**
- Look for database connection errors

### CORS errors in frontend:
- Verify `CORS_ORIGINS` matches your frontend URL exactly
- Make sure to restart backend after changing

### Can't connect to database:
- Check RDS security group allows port 3306
- Verify DATABASE_URL is correct in EB environment properties

### Frontend shows blank page:
- Check browser console (F12) for errors
- Verify `environment.prod.ts` has correct backend URL
- Check S3 bucket policy is public

---

## 💰 Cost: $0 for 12 Months!

All services are AWS Free Tier eligible:
- ✅ RDS: 750 hours/month
- ✅ EC2 (via EB): 750 hours/month
- ✅ S3: 5 GB storage

**Set billing alerts:** https://console.aws.amazon.com/billing/

---

## 🎓 What You Built:

```
Internet Users
     ↓
S3 Static Website (Angular)
     ↓
Application Load Balancer
     ↓  
EC2 Instance (Spring Boot via Elastic Beanstalk)
     ↓
RDS MySQL Database
```

---

## 📚 Additional Resources

- AWS Elastic Beanstalk: https://docs.aws.amazon.com/elasticbeanstalk/
- AWS RDS: https://docs.aws.amazon.com/rds/
- AWS S3: https://docs.aws.amazon.com/s3/

---

**🎉 Congratulations! Your application is live on AWS!**

No CLI needed - everything done through the console! 🚀
