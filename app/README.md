# Demo Spring Boot App

Small Spring Boot service used in a DevOps assignment. This README covers running the app **alone** (without Docker Compose/Kubernetes). For the full local stack (app + Postgres), see the repo root README.

## Prerequisites
- Java 21 (Temurin recommended)
- Maven (wrapper included: `./mvnw`)
- (Optional) A reachable PostgreSQL instance

## Quick start (no DB)
```bash
# from this app/ folder
./mvnw spring-boot:run
# or
./mvnw -DskipTests clean package && java -jar target/*.jar

App will listen on http://localhost:8080.

Configure database

The app reads these environment variables (mapped in application.properties):

| Env var       | Description          | Example                                 |
| ------------- | -------------------- | --------------------------------------- |
| `PORT`        | HTTP port (optional) | `8080`                                  |
| `JDBC_URL`    | JDBC URL             | `jdbc:postgresql://localhost:5432/demo` |
| `DB_USER`     | DB username          | `demo`                                  |
| `DB_PASSWORD` | DB password          | `change-me`                             |

Run with a local Postgres:

export JDBC_URL=jdbc:postgresql://localhost:5432/demo
export DB_USER=demo
export DB_PASSWORD=change-me
./mvnw spring-boot:run


Health checks

- Root: GET /actuator/health

- Liveness: GET /actuator/health/liveness

- Readiness: GET /actuator/health/readiness

(Actuator is enabled; probe subpaths are turned on.)
