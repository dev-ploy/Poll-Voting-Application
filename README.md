# 🗳️ Voting App - Full Stack Polling Application

A modern, full-stack voting application built with Angular and Spring Boot, allowing users to create polls and vote in real-time.

## 🚀 Quick Deploy Options

### Option 1: AWS (Recommended for Production)
```bash
# Complete AWS deployment with RDS MySQL + Elastic Beanstalk + S3
# FREE for 12 months with AWS Free Tier

# 📖 Read: AWS-QUICKSTART.md (30 minutes)
# 📖 Or: AWS-DEPLOYMENT-GUIDE.md (complete guide)

# Quick start:
.\setup-aws-tools.ps1    # Install AWS CLI
aws configure            # Setup credentials
eb init                  # Initialize Elastic Beanstalk
eb create               # Create environment
.\deploy-aws.ps1        # Automated deployment
```

### Option 2: Render (Free Hosting)
```bash
# Deploy to Render.com (FREE)
# 📖 See: Render deployment section below

# 1. Create MySQL on Railway.app (FREE)
# 2. Deploy backend to Render
# 3. Deploy frontend to Render Static Site
```

### Option 3: Vercel + Railway (Quick & Free)
```bash
# Frontend: Vercel, Backend: Railway, DB: Railway MySQL

npm install -g vercel
vercel --prod            # Deploy frontend
# Configure backend on Railway.app
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
npm install

# Install dependencies

# Start development server
npm start

# Open browser at http://localhost:4200
```

### Backend Setup

```bash
# Navigate to backend directory
cd backend

# Update application.properties
spring.datasource.url=jdbc:mysql://localhost:3306/votingapp
spring.datasource.username=root
spring.datasource.password=yourpassword

# Run Spring Boot application
./mvnw spring-boot:run

# Backend runs at http://localhost:8080
```

## ☁️ AWS Deployment Guide

Complete AWS deployment documentation is available:

| Document | Purpose | Time Required |
|----------|---------|---------------|
| 📖 **[AWS-GET-STARTED.md](AWS-GET-STARTED.md)** | Overview & getting started | 5 min read |
| 🏃 **[AWS-QUICKSTART.md](AWS-QUICKSTART.md)** | Fast deployment guide | 30 min |
| 📚 **[AWS-DEPLOYMENT-GUIDE.md](AWS-DEPLOYMENT-GUIDE.md)** | Complete step-by-step | 1-2 hours |
| 📋 **[AWS-DEPLOYMENT-SUMMARY.md](AWS-DEPLOYMENT-SUMMARY.md)** | Reference & commands | Quick lookup |

### AWS Architecture
```
Frontend (S3 + CloudFront) → Backend (Elastic Beanstalk) → Database (RDS MySQL)
```

### AWS Services Used
- **RDS MySQL** - Managed database (FREE tier: 750 hours/month)
- **Elastic Beanstalk** - Backend deployment (FREE tier: 750 hours/month)
- **S3** - Frontend hosting (FREE tier: 5GB storage)
- **CloudFront** - CDN for frontend (optional)

### Quick AWS Commands
```powershell
# Install AWS tools
.\setup-aws-tools.ps1

# Configure AWS
aws configure

# Deploy (after setup)
.\deploy-aws.ps1
```

### AWS Cost
- **Free Tier (12 months)**: $0/month
- **After Free Tier**: ~$23/month (without CloudFront)

📖 **Start Here**: [AWS-GET-STARTED.md](AWS-GET-STARTED.md)

---

## 🌐 Render Deployment Guide

For Render deployment instructions, see the Render section below or follow these guides:
- Backend deployment on Render
- MySQL database on Railway
- Frontend on Render Static Site

Complete Render deployment instructions are included in this README (see Render section).

---

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
