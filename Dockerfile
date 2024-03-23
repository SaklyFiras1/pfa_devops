# Stage 1: Build Angular frontend
FROM node:latest as angular-builder
WORKDIR /app/frontend
COPY frontend/ /app/frontend
RUN npm install && npm run build

# Stage 2: Build Spring Boot backend
FROM maven:latest as spring-builder
WORKDIR /app/backend
COPY ELearningManagement-backend/ /app/backend   # Make sure this directory exists

RUN mvn clean package -DskipTests

# Stage 3: Create final image
FROM openjdk:latest
WORKDIR /app
COPY --from=spring-builder /app/backend/target/backend-0.0.1-SNAPSHOT.jar /app/backend.jar
COPY --from=angular-builder /app/frontend/dist /app/frontend
EXPOSE 8080
CMD ["java", "-jar", "backend.jar"]
