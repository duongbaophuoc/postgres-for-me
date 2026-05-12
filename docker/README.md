# docker/

This folder contains a production-like PostgreSQL development environment built with Docker Compose.

## What is included

- `docker-compose.yml` - PostgreSQL 16 + pgAdmin 4 compose stack.
- `REQUIREMENTS.md` - Required tools, ports, and environment prerequisites.

## Purpose

Use this folder to launch a local PostgreSQL instance, connect with `psql` or pgAdmin, and run hands-on exercises safely in containers.

## Quick start

1. Open a terminal in this folder.
2. Start the stack:

```powershell
cd e:\ABC\NoSQL\PostgreSQL\docker
docker compose up -d
```

3. Confirm the services are running:

```powershell
docker compose ps
```

4. Connect to PostgreSQL:

```powershell
docker compose exec postgres psql -U engineer -d production_db
```

5. Open pgAdmin in your browser:

- URL: `http://localhost:8080`
- Email: `admin@engineering.com`
- Password: `admin`

## Example workflow

Create a test table and insert sample data:

```sql
CREATE TABLE app_users (
  id SERIAL PRIMARY KEY,
  username TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

INSERT INTO app_users (username) VALUES ('alice'), ('bob');
SELECT * FROM app_users;
```

## Shutdown and cleanup

```powershell
docker compose down -v
```

## Notes

- If your Docker installation uses the old command, use `docker-compose` instead of `docker compose`.
- Review `REQUIREMENTS.md` before running the stack.
