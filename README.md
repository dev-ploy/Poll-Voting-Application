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
