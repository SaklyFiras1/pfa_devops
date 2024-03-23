
# Stage 2: Build Spring Boot backend
FROM maven:latest as spring-builder
WORKDIR /app/backend
COPY ../backend/ /app/backend
RUN mvn clean package -DskipTests

# Stage 3: Create final image
FROM openjdk:latest
WORKDIR /app
COPY --from=spring-builder /app/backend/target/backend-0.0.1-SNAPSHOT.jar /app/backend.jar

EXPOSE 8080
CMD ["java", "-jar", "backend.jar"]
