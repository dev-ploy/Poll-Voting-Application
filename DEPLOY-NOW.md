# 🚀 Quick Deployment Guide - Render + Railway

## Deploy Your Poll Voting App in 20 Minutes (FREE!)

---

## ✅ What You'll Deploy

- **Database**: MySQL on Railway.app (FREE)
- **Backend**: Spring Boot on Render.com (FREE)
- **Frontend**: Angular on Render.com (FREE)

**Total Cost**: $0/month

---

## 📋 PART 1: Deploy Database (5 minutes)

### Step 1: Create Railway Account

1. Open: https://railway.app
2. Click **"Login"**
3. Choose **"Login with GitHub"**
4. Authorize Railway
5. ✅ You're in!

### Step 2: Create MySQL Database

1. Click **"New Project"**
2. Select **"Provision MySQL"**
3. Wait 1-2 minutes for provisioning
4. ✅ MySQL database created!

### Step 3: Get Database Credentials

1. Click on the **MySQL** service card
2. Go to **"Variables"** tab
3. **Copy these values** (you'll need them):

```
MYSQLHOST: containers-us-west-xxx.railway.app
MYSQLPORT: 6379
MYSQLDATABASE: railway
MYSQLUSER: root
MYSQLPASSWORD: xxxxxxxxxxxxx
```

**💡 TIP**: Keep this tab open or paste values in a text file!

---

## 📋 PART 2: Deploy Backend (7 minutes)

### Step 1: Login to Render

1. Open: https://render.com
2. Click **"Get Started"**
3. Choose **"Sign in with GitHub"**
4. Authorize Render
5. ✅ Logged in!

### Step 2: Create Web Service for Backend

1. Click **"New +"** (top right)
2. Select **"Web Service"**
3. Click **"Connect GitHub"** (if needed)
4. Find and select: **`Poll-Voting-Application`**
5. Click **"Connect"**

### Step 3: Configure Backend Service

Fill in these settings:

**Basic Settings:**
```
Name: poll-voting-backend
Region: Oregon (US West) or closest to you
Branch: main
Root Directory: backend/votingapp
```

**Build Settings:**
```
Runtime: Docker
Build Command: (leave empty - uses Dockerfile)
Start Command: (leave empty - uses Dockerfile)
```

**Instance Type:**
```
Select: Free
```

### Step 4: Add Environment Variables

Scroll to **"Environment Variables"** and click **"Add Environment Variable"**:

```
Key: SERVER_PORT
Value: 8080

Key: SPRING_PROFILES_ACTIVE
Value: production

Key: DATABASE_URL
Value: jdbc:mysql://[YOUR-MYSQLHOST]:[YOUR-MYSQLPORT]/[YOUR-MYSQLDATABASE]
Example: jdbc:mysql://containers-us-west-123.railway.app:6379/railway

Key: DB_USERNAME
Value: root

Key: DB_PASSWORD
Value: [YOUR-MYSQL-PASSWORD from Railway]

Key: CORS_ORIGINS
Value: https://poll-voting-frontend.onrender.com
(We'll update this after frontend deploy)
```

**⚠️ IMPORTANT**: Replace the bracketed values with actual values from Railway!

### Step 5: Deploy Backend

1. Click **"Create Web Service"**
2. Wait 5-7 minutes (Render builds your Spring Boot app)
3. Watch the logs - you'll see Maven downloading dependencies
4. When you see: ✅ **"Live"** - Backend is deployed!

### Step 6: Get Backend URL

1. Copy your backend URL from the top:
   ```
   https://poll-voting-backend.onrender.com
   ```
2. **Save this URL** - you'll need it for frontend!

### Step 7: Test Backend

Open in browser:
```
https://poll-voting-backend.onrender.com/actuator/health
```

You should see: `{"status":"UP"}`

If it shows error, check the logs in Render dashboard.

---

## 📋 PART 3: Update Frontend Config (2 minutes)

### Update Environment File

We need to update the frontend to point to your backend URL.

**Option A: Via GitHub Web Interface**

1. Go to: https://github.com/dev-ploy/Poll-Voting-Application
2. Navigate to: `frontend/poll-app/src/environments/environment.prod.ts`
3. Click the **pencil icon** (Edit)
4. Change the content to:

```typescript
export const environment = {
  production: true,
  apiUrl: 'https://poll-voting-backend.onrender.com'
};
```

**⚠️ Replace with YOUR actual backend URL!**

5. Scroll down and click **"Commit changes"**
6. Click **"Commit changes"** again

**Option B: Via Local VSCode**

Run these commands:
```powershell
cd E:\Voting-App
code frontend\poll-app\src\environments\environment.prod.ts
```

Update the file, then:
```powershell
git add .
git commit -m "Update backend URL for production"
git push origin main
```

---

## 📋 PART 4: Deploy Frontend (5 minutes)

### Step 1: Create Static Site

1. Go back to Render Dashboard
2. Click **"New +"** again
3. This time select **"Static Site"**
4. Select repository: **`Poll-Voting-Application`**
5. Click **"Connect"**

### Step 2: Configure Frontend Service

**Basic Settings:**
```
Name: poll-voting-frontend
Branch: main
Root Directory: frontend/poll-app
```

**Build Settings:**
```
Build Command: npm install && npm run build:prod
Publish Directory: dist/poll-app/browser
```

### Step 3: Add Environment Variable (Optional)

```
Key: NODE_VERSION
Value: 18
```

### Step 4: Deploy Frontend

1. Click **"Create Static Site"**
2. Wait 3-5 minutes (building Angular app)
3. When you see: ✅ **"Live"** - Frontend is deployed!

### Step 5: Get Frontend URL

Your frontend will be live at:
```
https://poll-voting-frontend.onrender.com
```

---

## 📋 PART 5: Final Configuration (2 minutes)

### Update Backend CORS

1. Go to Render Dashboard
2. Click on **poll-voting-backend** service
3. Go to **"Environment"** tab
4. Find `CORS_ORIGINS` variable
5. Click **"Edit"**
6. Update to:
   ```
   https://poll-voting-frontend.onrender.com
   ```
7. Click **"Save Changes"**
8. Backend will automatically restart (30-60 seconds)

---

## 🎉 DEPLOYMENT COMPLETE!

### Your Live URLs

**Frontend (Angular App)**:
```
https://poll-voting-frontend.onrender.com
```

**Backend (API)**:
```
https://poll-voting-backend.onrender.com
```

**Database**:
```
MySQL on Railway (internal access only)
```

---

## ✅ Test Your Application

### 1. Test Backend Health
```
https://poll-voting-backend.onrender.com/actuator/health
```
Should return: `{"status":"UP"}`

### 2. Test Backend API
```
https://poll-voting-backend.onrender.com/api/polls
```
Should return empty array: `[]`

### 3. Test Frontend
```
https://poll-voting-frontend.onrender.com
```
Should show your Poll Voting Application!

### 4. Create a Test Poll
1. Open frontend URL
2. Create a new poll
3. Add options
4. Submit and vote!

---

## ⚠️ Important Notes

### Free Tier Limitations

**Render Free Tier:**
- Services spin down after 15 minutes of inactivity
- First request after inactivity takes 30-50 seconds (cold start)
- 750 hours/month of usage

**Railway Free Tier:**
- $5 credit/month
- 500 hours of database runtime
- 1 GB storage

### Cold Start Behavior
- When inactive, services "sleep"
- First visit will be slow (30-50 seconds)
- Subsequent visits are fast
- This is normal for free tier!

---

## 🔧 Troubleshooting

### Backend won't start
```
Check Render logs:
1. Dashboard → poll-voting-backend → Logs tab
2. Look for errors in red

Common fixes:
- Verify DATABASE_URL format is correct
- Check DB_PASSWORD has no special characters
- Ensure Railway MySQL is running
```

### Frontend can't connect to backend
```
1. Check browser console (F12)
2. Verify environment.prod.ts has correct backend URL
3. Check CORS_ORIGINS in backend environment variables
4. Ensure backend is "Live" in Render
```

### Database connection failed
```
1. Go to Railway → MySQL service
2. Check service is running (green dot)
3. Verify all MYSQL* environment variables in Render
4. Test connection string format
```

### CORS Errors
```
Error: "Access to XMLHttpRequest blocked by CORS policy"

Fix:
1. Render Dashboard → poll-voting-backend
2. Environment → Edit CORS_ORIGINS
3. Set to exact frontend URL (including https://)
4. Save and restart
```

---

## 🔄 Redeployment

### When you make code changes:

**Backend:**
```powershell
git add .
git commit -m "Your changes"
git push origin main
```
Render auto-deploys in 5-7 minutes.

**Frontend:**
```powershell
git add .
git commit -m "Your changes"
git push origin main
```
Render auto-deploys in 3-5 minutes.

---

## 📊 Monitoring

### View Logs

**Backend:**
1. Render Dashboard → poll-voting-backend
2. Click **"Logs"** tab
3. Real-time logs appear here

**Frontend:**
1. Render Dashboard → poll-voting-frontend
2. Click **"Logs"** tab

### Check Status

- **Green dot** = Running
- **Yellow dot** = Building/Deploying
- **Red dot** = Failed
- **Gray dot** = Sleeping (inactive)

---

## 💡 Pro Tips

1. **Bookmark your URLs** - Save them for easy access
2. **Check logs regularly** - Catch errors early
3. **Use Railway dashboard** - Monitor database usage
4. **Set up health checks** - Keep services awake
5. **Git commit often** - Auto-deployment is instant

---

## 🎯 Next Steps

After successful deployment:

1. ✅ Test all features thoroughly
2. 📝 Document your URLs
3. 🔒 Secure your environment variables
4. 📊 Monitor usage on Railway
5. 🚀 Share your app!

---

## 📞 Need Help?

- **Render Docs**: https://render.com/docs
- **Railway Docs**: https://docs.railway.app
- **Your Repo**: https://github.com/dev-ploy/Poll-Voting-Application

---

## 🎉 You're Live!

Your Poll Voting Application is now running on:
- ✅ Professional cloud infrastructure
- ✅ Free tier hosting
- ✅ Auto-scaling capabilities
- ✅ Continuous deployment from GitHub

**Congratulations! 🎊**

---

*Total time: ~20 minutes*  
*Total cost: $0/month*  
*Status: Production ready!*
