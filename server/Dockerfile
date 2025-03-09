# Use buildx with platform argument instead of --platform flag in FROM
FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /app
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
# First resolve dependencies separately to improve build caching
RUN chmod +x mvnw
RUN ./mvnw dependency:go-offline || return 0

# Now copy source and build
COPY src src
RUN ./mvnw package -DskipTests

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
COPY .env .env
EXPOSE 8080
ENTRYPOINT ["/bin/sh", "-c", ". .env && java -jar app.jar"]
#ENTRYPOINT ["java", "-jar", "app.jar"]