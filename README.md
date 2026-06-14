# GoIT DevOps

## Branches

| Branch | Topic |
|--------|-------|
| `lesson-3` | Bash scripting in Linux |
| `lesson-4` | Containerized Django + PostgreSQL + Nginx with Docker Compose |

---

## Lesson 4 — Django + PostgreSQL + Nginx with Docker Compose

### Stack

- **Django** — web application (Python 3.10)
- **PostgreSQL 14** — database
- **Nginx** — reverse proxy on port 80

### Project structure

```
├── django/
│   ├── Dockerfile
│   ├── requirements.txt
│   └── goit/          # Django project
├── nginx/
│   └── default.conf   # Nginx reverse proxy config
├── docker-compose.yaml
└── .env.example
```

### Quick start

#### Option A — automated (installs tools + starts services)

1. Copy the environment file and fill in your values:
   ```bash
   cp .env.example .env
   ```

2. Run the setup script (installs Docker, Python, Django, then starts all services):
   ```bash
   bash install_dev_tools.sh
   ```

3. Open [http://localhost](http://localhost) in your browser.

#### Option B — manual

1. Copy the environment file and fill in your values:
   ```bash
   cp .env.example .env
   ```

2. Start all services:
   ```bash
   docker-compose up -d
   ```

3. Open [http://localhost](http://localhost) in your browser.

### Environment variables

See `.env.example` for all required variables:

| Variable | Description | Default |
|----------|-------------|---------|
| `POSTGRES_HOST` | DB hostname (Docker service name) | `db` |
| `POSTGRES_PORT` | DB port | `5432` |
| `POSTGRES_USER` | DB user | `django_user` |
| `POSTGRES_DB` | DB name | `django_db` |
| `POSTGRES_PASSWORD` | DB password | — |

### Stopping

```bash
docker-compose down
```

To also remove the database volume:
```bash
docker-compose down -v
```
