#!/usr/bin/env bash
# Start script for Render deployment

echo "Starting Spring Boot application..."

# Navigate to backend directory and run the jar
cd backend/votingapp
java -jar target/*.jar