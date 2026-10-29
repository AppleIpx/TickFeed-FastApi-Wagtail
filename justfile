export COMPOSE_FILE := "docker-compose.local.yml"

# Default command to list all available commands.
default:
    @just --list

# build: Build python image.
build *args:
    @echo "Building python image..."
    @docker compose build {{args}}

# up: Start up containers.
up:
    @echo "Starting up containers..."
    @docker compose up -d --remove-orphans

# down: Stop containers.
down:
    @echo "Stopping containers..."
    @docker compose down

# prune: Remove containers and their volumes.
prune *args:
    @echo "Killing containers and removing volumes..."
    @docker compose down -v {{args}}

# logs: View container logs.
logs *args:
    @docker compose logs -f {{args}}

# alembic: Executes an `alembic` command, e.g. `just alembic revision --autogenerate -m "..."`.
alembic +args:
    @docker compose run --rm fastapi alembic {{args}}

# pytest: Run tests with pytest inside the fastapi container.
pytest *args:
    @docker compose run --rm fastapi pytest {{args}}

# test-ci: Run tests in an isolated stack, the same way CI does.
test-ci:
    #!/usr/bin/env bash
    set -euo pipefail
    export COMPOSE_FILE=docker-compose.test.yml
    trap 'docker compose down -v --remove-orphans' EXIT
    docker compose build
    docker compose up -d --wait postgres
    docker compose run --rm fastapi alembic upgrade head
    docker compose run --rm fastapi bash scripts/tests-start.sh
