FROM openjdk:17-jdk-slim

WORKDIR /app

# Copy Maven wrapper and pom.xml
COPY backend/votingapp/mvnw .
COPY backend/votingapp/mvnw.cmd .
COPY backend/votingapp/.mvn .mvn
COPY backend/votingapp/pom.xml .

# Copy source code
COPY backend/votingapp/src src

# Make mvnw executable
RUN chmod +x ./mvnw

# Build the application
RUN ./mvnw clean package -DskipTests

# Expose port
EXPOSE 8080

# Run the application (find the jar dynamically for version flexibility)
CMD ["sh", "-c", "java -jar target/*.jar"]