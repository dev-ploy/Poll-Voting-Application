#!/usr/bin/env bash
# Build script for Render deployment

echo "Starting build process..."

# Navigate to backend directory
cd backend/votingapp

# Make mvnw executable
chmod +x mvnw

# Clean and build the application
./mvnw clean package -DskipTests

echo "Build completed successfully!"