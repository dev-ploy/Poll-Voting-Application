# ✅ AWS Deployment Checklist - Follow This Step by Step

## 🎉 STEP 1: Build Backend JAR ✅ COMPLETED!

**Status:** ✅ **DONE!**

**JAR Location:**
```
E:\Voting-App\backend\votingapp\target\votingapp-0.0.1-SNAPSHOT.jar
```

File Explorer has been opened to this location. You'll need this file for Part 2!

---

## 🗄️ STEP 2: Create MySQL Database on AWS (15 minutes)

### What to do:

1. **Open AWS Console:**
   - Go to: https://console.aws.amazon.com
   - Sign in to your AWS account

2. **Navigate to RDS:**
   - Search "RDS" in the top search bar
   - Click on "RDS" service

3. **Create Database:**
   - Click orange **"Create database"** button
   - Follow the settings below:

### Database Settings:

```
✅ Standard create
Engine: MySQL
Version: MySQL 8.0.35
Template: ✅ Free tier (IMPORTANT!)

Settings:
  DB instance identifier: votingapp-db
  Master username: admin
  Master password: [Create strong password]
  Confirm password: [Same password]

📝 WRITE DOWN YOUR PASSWORD:
Password: _________________________

Instance: db.t3.micro (auto-selected)
Storage: 20 GB
Public access: ✅ YES (IMPORTANT!)
VPC security group: Create new
  Name: votingapp-db-sg

Additional config:
  Initial database name: votingapp
  ✅ Enable automated backups
```

4. **Click "Create database"**

5. **⏳ Wait 5-10 minutes** (Status: Creating → Available)

### After Database is Available:

**Configure Security Group:**

1. Click on **votingapp-db**
2. Go to **"Connectivity & security"** tab
3. Click the **Security group** link
4. Click **"Edit inbound rules"**
5. Click **"Add rule"**
6. Configure:
   ```
   Type: MySQL/Aurora
   Port: 3306
   Source: Anywhere-IPv4 (0.0.0.0/0)
   ```
7. Click **"Save rules"**

**Get Database Endpoint:**

1. Back in RDS → votingapp-db
2. Copy the **Endpoint** (Connectivity & security tab):
   ```
   votingapp-db.xxxxxxxxxxxxx.us-east-1.rds.amazonaws.com
   ```

**📝 SAVE THIS INFO:**
```
Endpoint: votingapp-db.xxxxxxxxxxxxx.us-east-1.rds.amazonaws.com
Port: 3306
Database: votingapp
Username: admin
Password: [your password]

Full URL: jdbc:mysql://votingapp-db.xxxxxxxxxxxxx.us-east-1.rds.amazonaws.com:3306/votingapp
```

✅ **Mark as done when complete:** [ ]

---

## 🖥️ STEP 3: Deploy Backend to Elastic Beanstalk (20 minutes)

### What to do:

1. **Navigate to Elastic Beanstalk:**
   - Search "Elastic Beanstalk" in AWS Console
   - Click on it

2. **Create Application:**
   - Click **"Create application"**

### Application Settings:

```
Application name: poll-voting-app

Platform:
  Platform: Java
  Platform branch: Corretto 17 running on 64bit Amazon Linux 2023
  Platform version: (use recommended)

Application code:
  ✅ Upload your code
  Source code origin: Local file
  
  👉 Click "Choose file"
  👉 Browse to: E:\Voting-App\backend\votingapp\target\
  👉 Select: votingapp-0.0.1-SNAPSHOT.jar

Presets:
  ✅ Single instance (free tier eligible)
```

3. **Click "Next"**

### Service Access:

```
✅ Create and use new service role
Service role name: aws-elasticbeanstalk-service-role
EC2 instance profile: Create new (aws-elasticbeanstalk-ec2-role)
```

4. **Click "Next"**

### Networking:

```
VPC: Default VPC
✅ Public IP address: Activated
Instance subnets: Select at least 2 availability zones
```

5. **Click "Next"**

### Instance Settings:

```
Environment type: Single instance
Instance types: t2.micro, t3.micro
```

6. **Click "Next"**

### Environment Properties (CRITICAL!):

**Click "Add environment property" for each:**

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
  (⚠️ Replace [YOUR-RDS-ENDPOINT] with actual endpoint from Step 2!)

Property 4:
  Name: DB_USERNAME
  Value: admin

Property 5:
  Name: DB_PASSWORD
  Value: [your-database-password]
  (⚠️ Use password from Step 2!)

Property 6:
  Name: CORS_ORIGINS
  Value: *
```

7. **Click "Next"** → Review → **"Submit"**

8. **⏳ Wait 10-15 minutes** for deployment

### After Deployment:

**Get Backend URL:**

1. In Elastic Beanstalk, click your application
2. Copy the **Domain** URL:
   ```
   poll-voting-app.us-east-1.elasticbeanstalk.com
   ```

**Test It:**

Open in browser:
```
http://poll-voting-app.us-east-1.elasticbeanstalk.com/api/polls
```

**Expected:** `[]` (empty array)

**📝 SAVE BACKEND URL:**
```
Backend URL: http://poll-voting-app.us-east-1.elasticbeanstalk.com
```

✅ **Mark as done when complete:** [ ]

---

## 🌐 STEP 4: Update and Build Frontend (5 minutes)

### What to do:

1. **Edit Frontend Environment File:**

Open: `E:\Voting-App\frontend\poll-app\src\environments\environment.prod.ts`

Replace with YOUR backend URL:
```typescript
export const environment = {
  production: true,
  apiUrl: 'http://poll-voting-app.us-east-1.elasticbeanstalk.com'
};
```

Save the file.

2. **Build Frontend:**

```powershell
cd E:\Voting-App\frontend\poll-app
npm install
npm run build:prod
```

⏳ Wait 2-3 minutes.

**Verify:** Files should be in `E:\Voting-App\frontend\poll-app\dist\poll-app\browser\`

✅ **Mark as done when complete:** [ ]

---

## 📦 STEP 5: Deploy Frontend to S3 (10 minutes)

### What to do:

1. **Navigate to S3:**
   - Search "S3" in AWS Console
   - Click on S3 service

2. **Create Bucket:**
   - Click **"Create bucket"**

### Bucket Settings:

```
Bucket name: poll-voting-frontend-yourname
(Replace 'yourname' with something unique like your GitHub username!)

Region: US East (N. Virginia) us-east-1

Object Ownership: ACLs disabled

Block Public Access:
  ⬜ UNCHECK "Block all public access"
  ✅ Check the acknowledgment box

Bucket Versioning: Disable
Default encryption: Disable
```

3. **Click "Create bucket"**

### Upload Files:

1. Click on your bucket: **poll-voting-frontend-yourname**
2. Click **"Upload"**
3. Click **"Add files"**
4. Browse to: `E:\Voting-App\frontend\poll-app\dist\poll-app\browser`
5. **Select ALL files inside browser folder**
6. Click **"Upload"**

⏳ Wait for upload to complete.

### Enable Static Website Hosting:

1. Go to **"Properties"** tab
2. Scroll to **"Static website hosting"**
3. Click **"Edit"**
4. Configure:
   ```
   ✅ Enable
   Hosting type: Host a static website
   Index document: index.html
   Error document: index.html
   ```
5. Click **"Save changes"**

**📝 Copy Website Endpoint:**
```
http://poll-voting-frontend-yourname.s3-website-us-east-1.amazonaws.com
```

### Make Files Public:

1. Go to **"Permissions"** tab
2. Scroll to **"Bucket policy"**
3. Click **"Edit"**
4. Paste this (replace YOUR-BUCKET-NAME):

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

5. Click **"Save changes"**

✅ **Mark as done when complete:** [ ]

---

## 🔗 STEP 6: Update Backend CORS (5 minutes)

### What to do:

1. **Go to Elastic Beanstalk**
2. Click **poll-voting-app**
3. Click **"Configuration"**
4. Find **"Software"** → Click **"Edit"**
5. Scroll to **"Environment properties"**
6. Find `CORS_ORIGINS` and change to:
   ```
   http://poll-voting-frontend-yourname.s3-website-us-east-1.amazonaws.com
   ```
7. Click **"Apply"**

⏳ Wait 2-3 minutes for update.

✅ **Mark as done when complete:** [ ]

---

## 🎉 STEP 7: Test Your Application!

### What to do:

1. **Open Frontend URL:**
   ```
   http://poll-voting-frontend-yourname.s3-website-us-east-1.amazonaws.com
   ```

2. **Test the App:**
   - Create a poll
   - Add options
   - Submit
   - Vote on it
   - See results!

3. **Verify Backend:**
   ```
   http://poll-voting-app.us-east-1.elasticbeanstalk.com/api/polls
   ```
   Should show your created poll in JSON format.

✅ **Mark as done when complete:** [ ]

---

## 📝 YOUR DEPLOYED APPLICATION

**Save these URLs:**

```
Frontend: http://poll-voting-frontend-yourname.s3-website-us-east-1.amazonaws.com
Backend:  http://poll-voting-app.us-east-1.elasticbeanstalk.com
Database: votingapp-db.xxxxx.us-east-1.rds.amazonaws.com:3306
```

---

## 🆘 Troubleshooting

### Backend shows 502 error:
- Check Elastic Beanstalk **Logs**
- Verify DATABASE_URL is correct
- Check DB_PASSWORD matches

### CORS errors:
- Verify CORS_ORIGINS matches frontend URL exactly
- Restart backend after changing

### Frontend blank page:
- Check browser console (F12) for errors
- Verify backend URL in environment.prod.ts
- Check S3 bucket policy is public

---

## 💰 Cost: $0 for 12 Months!

All services are Free Tier:
- ✅ RDS: 750 hours/month
- ✅ EC2: 750 hours/month
- ✅ S3: 5 GB storage

---

## 🎓 What You're Building:

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

## 📞 Need Help?

Refer to: `AWS-CONSOLE-ONLY-DEPLOYMENT.md` for detailed instructions.

---

**🚀 Current Status:**
- ✅ Backend JAR: BUILT
- ⏭️ Next: Create MySQL Database (Step 2)

**Start with Step 2 now!**

Go to: https://console.aws.amazon.com
