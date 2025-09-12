FROM maven:3.9.8-eclipse-temurin-21 AS build
WORKDIR /src
COPY app/pom.xml ./app/pom.xml
RUN --mount=type=cache,target=/root/.m2 mvn -f app/pom.xml -q -DskipTests dependency:go-offline
COPY app ./app
RUN --mount=type=cache,target=/root/.m2 mvn -f app/pom.xml -q -DskipTests clean package

FROM eclipse-temurin:21-jre
WORKDIR /app
ENV PORT=8080
COPY --from=build /src/app/target/*.jar /app/app.jar
EXPOSE 8080
ENTRYPOINT ["java","-XX:MaxRAMPercentage=75.0","-jar","/app/app.jar"]