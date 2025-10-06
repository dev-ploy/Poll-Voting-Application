# 🗳️ Voting App - Full Stack Polling Application

A modern, full-stack voting application built with Angular and Spring Boot, allowing users to create polls and vote in real-time.

## 🚀 Quick Deploy (5 minutes)

```bash
# 1. Deploy backend to Render (FREE)
# Sign up at render.com → New Web Service → Connect GitHub
# Add MySQL database → Copy DATABASE_URL

# 2. Update environment
# Edit src/environments/environment.prod.ts with your Render URL

# 3. Deploy frontend to Vercel (FREE)
npm install -g vercel
vercel login
vercel --prod

# Done! Your app is live 🎉
```

## 🚀 Tech Stack

### Frontend
- **Angular 20.3** - Modern web framework
- **TypeScript** - Type-safe JavaScript
- **Bootstrap 5** - Responsive UI components
- **RxJS** - Reactive programming

### Backend
- **Spring Boot 3.x** - Java framework
- **Hibernate/JPA** - ORM for database
- **MySQL** - Relational database
- **Maven** - Dependency management

## ✨ Features

- ✅ Create custom polls with multiple options
- ✅ Real-time voting with instant results
- ✅ Responsive design for mobile and desktop
- ✅ Clean, modern UI with animations
- ✅ Form validation and error handling
- ✅ Persistent data storage

## 🖥️ Local Development

### Prerequisites
- Node.js 18+ and npm
- Java 17+
- MySQL 8+
- Git

### Frontend Setup

```bash
# Clone repository
git clone <your-repo-url>
cd poll-app

# Install dependencies
npm install

# Start development server
npm start

# Open browser at http://localhost:4200
```

### Backend Setup

```bash
# Navigate to backend directory
cd backend

# Update application.properties
spring.datasource.url=jdbc:mysql://localhost:3306/polldb
spring.datasource.username=root
spring.datasource.password=yourpassword

# Run Spring Boot application
./mvnw spring-boot:run

# Backend runs at http://localhost:8080
```

## 🌐 Deployment (100% FREE)

Deploy your full-stack app for free using Render for backend/database and Vercel for frontend.

### Option 1: Render (Backend + MySQL) - **RECOMMENDED**

**Why Render?**
- ✅ 750 hours/month free (enough for 24/7)
- ✅ Free PostgreSQL/MySQL database
- ✅ Auto-deploy from GitHub
- ✅ Free SSL certificates

#### Step 1: Deploy Backend to Render

1. **Sign up** at [render.com](https://render.com)

2. **Create Web Service:**
   - Click "New +" → "Web Service"
   - Connect your GitHub repository (backend)
   - Configure:
     - **Name:** `voting-app-backend`
     - **Environment:** `Java`
     - **Build Command:** `./mvnw clean install -DskipTests`
     - **Start Command:** `java -jar target/*.jar`
     - **Instance Type:** `Free`

3. **Add Environment Variables:**
   ```
   DATABASE_URL=<will-add-after-database-setup>
   FRONTEND_URL=<will-add-after-frontend-deployment>
   ```

#### Step 2: Create MySQL Database on Render

1. **Create Database:**
   - Click "New +" → "MySQL"
   - **Name:** `voting-app-db`
   - **Plan:** `Free`
   - Copy the **Internal Database URL**

2. **Update Backend Environment:**
   - Go to your Web Service → "Environment"
   - Update `DATABASE_URL` with the MySQL URL
   - Backend will auto-redeploy

#### Step 3: Update application.properties

```properties
# Server
server.port=${PORT:8080}

# Database (Render provides this)
spring.datasource.url=${DATABASE_URL}
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# JPA/Hibernate
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=false
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect

# CORS
spring.web.cors.allowed-origins=${FRONTEND_URL:http://localhost:4200}
spring.web.cors.allowed-methods=GET,POST,PUT,DELETE,OPTIONS
spring.web.cors.allowed-headers=*
```

### Option 2: Vercel (Frontend) - **RECOMMENDED**

**Why Vercel?**
- ✅ Unlimited deployments
- ✅ 100GB bandwidth/month free
- ✅ Auto-deploy from GitHub
- ✅ Global CDN

#### Deploy Frontend to Vercel

1. **Update `src/environments/environment.prod.ts`:**
   ```typescript
   export const environment = {
     production: true,
     apiUrl: 'https://voting-app-backend.onrender.com/api/polls'
   };
   ```

2. **Deploy via CLI:**
   ```bash
   # Install Vercel CLI
   npm install -g vercel

   # Login
   vercel login

   # Deploy
   vercel --prod
   ```

3. **Or Deploy via Dashboard:**
   - Go to [vercel.com](https://vercel.com)
   - Click "Add New" → "Project"
   - Import your GitHub repository
   - Configure:
     - **Framework:** Angular
     - **Build Command:** `npm run build:prod`
     - **Output Directory:** `dist/poll-app/browser`
   - Click "Deploy"

4. **Update Backend CORS:**
   - Go to Render dashboard → Your backend service
   - Update `FRONTEND_URL` with your Vercel URL
   - Example: `https://your-app.vercel.app`

### Alternative: Railway (Backend + MySQL) - ALSO FREE

**Free Tier:** $5 credit/month (~500 hours)

1. **Sign up** at [railway.app](https://railway.app)
2. **New Project** → Deploy from GitHub
3. **Add MySQL** database
4. Railway auto-provides `DATABASE_URL`
5. Add `FRONTEND_URL` environment variable

### Alternative: Netlify (Frontend) - ALSO FREE

**Free Tier:** 100GB bandwidth, unlimited builds

```bash
# Install Netlify CLI
npm install -g netlify-cli

# Login
netlify login

# Deploy
netlify deploy --prod
```

## 🔧 Configuration Files

### `vercel.json` (for Vercel deployment)
```json
{
  "version": 2,
  "routes": [
    {
      "src": "/(.*)",
      "dest": "/index.html"
    }
  ],
  "buildCommand": "npm run build:prod",
  "outputDirectory": "dist/poll-app/browser"
}
```

### Environment Files

**Development:** `src/environments/environment.ts`
```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:8080/api/polls'
};
```

**Production:** `src/environments/environment.prod.ts`
```typescript
export const environment = {
  production: true,
  apiUrl: 'https://your-backend.onrender.com/api/polls'
};
```

## 🧪 Testing

```bash
# Frontend tests
npm test

# Backend tests
cd backend
./mvnw test

# E2E tests
npm run e2e
```

## 📊 Cost Breakdown

| Service | Free Tier | Cost |
|---------|-----------|------|
| **Render (Backend)** | 750 hrs/month | **FREE** |
| **Render (MySQL)** | 1GB storage | **FREE** |
| **Vercel (Frontend)** | 100GB bandwidth | **FREE** |
| **Total** | - | **$0/month** 🎉 |

## 🐛 Troubleshooting

### CORS Errors
- Ensure `FRONTEND_URL` in backend matches your Vercel URL exactly
- Check CORS configuration in `WebConfig.java`
- Redeploy backend after changes

### Database Connection Failed
- Verify `DATABASE_URL` is set correctly
- Check database service is running
- Review backend logs in Render

### Build Errors
- Clear `node_modules` and reinstall: `npm ci`
- Clear Angular cache: `npm run ng cache clean`
- Check Node.js version: `node -v` (should be 18+)

## 📁 Project Structure

```
poll-app/
├── src/
│   ├── app/
│   │   ├── poll/              # Poll component
│   │   ├── poll.service.ts    # API service
│   │   ├── poll.models.ts     # TypeScript interfaces
│   │   └── app.routes.ts      # Routing configuration
│   ├── environments/          # Environment configs
│   └── index.html
├── public/                    # Static assets
├── vercel.json               # Vercel configuration
├── angular.json              # Angular CLI config
├── package.json              # Dependencies
└── README.md                 # This file
```

## 🔐 Security Notes

For production use, consider adding:
- JWT authentication
- Input sanitization
- Rate limiting
- HTTPS enforcement
- Database backups

## 📝 License

MIT License - feel free to use for your portfolio!

## 👨‍💻 Author

Your Name - [GitHub](https://github.com/yourusername) | [LinkedIn](https://linkedin.com/in/yourprofile)

## 🙏 Acknowledgments

- Angular team for the awesome framework
- Spring Boot for the robust backend
- Free hosting providers (Render, Vercel) for making deployment accessible

---

**⭐ Star this repo if you find it helpful!**
