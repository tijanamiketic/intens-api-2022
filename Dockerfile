
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

COPY pom.xml .
RUN mvn -q -B dependency:go-offline

COPY src ./src
RUN mvn -q -B package -DskipTests


FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

ENV PORT=8081
EXPOSE 8081

COPY --from=build /app/target/*-SNAPSHOT.jar app.jar

ENTRYPOINT ["java","-jar","/app/app.jar","--server.port=${PORT}"]
