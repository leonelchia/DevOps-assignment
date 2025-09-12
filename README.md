# DevOps-assignment


Local Development & Testing (Docker Compose)

Spin up the Spring Boot app and a local PostgreSQL with one command, verify health, and iterate quickly.

Prerequisites

- Docker Desktop (Compose v2)

- (Optional) psql for DB access

- (Optional) jq for pretty JSON in health checks

Quick Start
# from repo root
docker compose --profile db up --build


Verify it’s running:

# App home
curl -s http://localhost:8080/

# App health
curl -s http://localhost:8080/actuator/health | jq .

# DB health (appears once JDBC is wired)
curl -s http://localhost:8080/actuator/health/db | jq .


You should see status: "UP" and database: "PostgreSQL" for the DB endpoint.

What the Compose file does

app

Builds the Spring Boot image from Dockerfile and exposes port 8080.

Reads DB config from env (JDBC_URL, DB_USER, DB_PASSWORD) which are mapped to Spring via application.properties.

Waits for the DB to be healthy before starting (depends_on with health condition).

Includes an HTTP healthcheck on http://127.0.0.1:8080/.

db

Runs Bitnami PostgreSQL 16.

Creates database/user with the env you specify.

Exposes the DB on host 5432 (for local psql).

Persists data in a named Docker volume pgdata.

Is enabled via the db profile (--profile db).

Configuration

Defaults (override via env or a .env file):

| Variable      | Default                          | Used by        |
| ------------- | -------------------------------- | -------------- |
| `PORT`        | `8080`                           | app container  |
| `JDBC_URL`    | `jdbc:postgresql://db:5432/demo` | Spring DS URL  |
| `DB_USER`     | `demo`                           | Spring DS user |
| `DB_PASSWORD` | `change-me`                      | Spring DS pass |


You can alternatively use SPRING_DATASOURCE_URL/USERNAME/PASSWORD.
Current setup uses JDBC_URL/DB_USER/DB_PASSWORD with placeholders in application.properties.

Logs & Diagnostics
# Tail logs (use the same profile you started with)
docker compose --profile db logs -f app
docker compose --profile db logs -f db

# Look for Hikari (DB pool) startup
docker compose --profile db logs app | grep -i hikari


Expected lines:

HikariPool-1 - Starting...
HikariPool-1 - Added connection ...
HikariPool-1 - Start completed.

Database Access From Host
PGPASSWORD=<your DB_PASSWORD> psql \
  -h 127.0.0.1 -p 5436 -U demo -d demo -c 'select 1'

Stopping & Resetting
# Stop containers
docker compose --profile db down

# Stop and remove the data volume (DANGER: wipes local DB data)
docker compose --profile db down -v
# or: docker volume rm <project>_pgdata
