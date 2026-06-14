#!/bin/bash
set -e

# Update package list and install curl
apt update
if command -v curl &> /dev/null; then
    echo "curl: $(curl --version | head -1)"
else
    apt install -y curl
fi

# Install Docker
if command -v docker &> /dev/null; then
    echo "docker: $(docker --version)"
else
    curl -fsSL https://get.docker.com | sh
    echo "docker: $(docker --version)"
fi

# Install Docker Compose
if docker compose version &> /dev/null; then
    echo "docker compose: $(docker compose version)"
else
    echo "docker compose plugin not found"
fi

# Install Python and pip
if command -v python3 &> /dev/null; then
    echo "python: $(python3 --version)"
else
    apt install -y python3 python3-pip
    echo "python: $(python3 --version)"
fi

# Install Django
if python3 -m django --version &> /dev/null; then
    echo "django: $(python3 -m django --version)"
else
    pip3 install django
    echo "django: $(python3 -m django --version)"
fi

# Start project with Docker Compose
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
COMPOSE_FILE="$SCRIPT_DIR/docker-compose.yaml"

if [ ! -f "$COMPOSE_FILE" ]; then
    echo "docker-compose.yaml not found at $SCRIPT_DIR, skipping"
else
    echo "Starting services with Docker Compose..."
    docker compose -f "$COMPOSE_FILE" up -d
    echo "Services started. Open http://localhost in your browser."
fi
