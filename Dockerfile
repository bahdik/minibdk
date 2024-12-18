# Stage 1: Build the application
FROM maven:3.8.4-openjdk-11 AS build

WORKDIR /app

# Copy pom.xml and other necessary files
COPY pom.xml /app/
COPY src /app/src/

# Build the JAR file, skipping tests
RUN mvn clean package -DskipTests

# Stage 2: Run the application
FROM openjdk:11-jre-slim

WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/target/hello-world-0.0.1-SNAPSHOT.jar /app/hello-world.jar

# Run the Spring Boot application
CMD ["java", "-jar", "/app/hello-world.jar"]

#testcommit1
