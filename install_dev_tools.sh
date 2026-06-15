#!/bin/bash
set -e

# Update package list and install prerequisites
sudo apt update
sudo apt install -y ca-certificates curl

# Install Docker using the official repository method
if command -v docker &> /dev/null; then
    echo "docker: $(docker --version)"
else
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    echo "docker: $(docker --version)"
fi

# Install Docker Compose plugin
if docker compose version &> /dev/null; then
    echo "docker compose: $(docker compose version)"
else
    sudo apt install -y docker-compose-plugin
    echo "docker compose: $(docker compose version)"
fi

# Install Python 3.10
REQUIRED_PYTHON="3.10"
if command -v python3 &> /dev/null; then
    INSTALLED=$(python3 --version 2>&1 | awk '{print $2}' | cut -d. -f1,2)
    if [ "$INSTALLED" = "$REQUIRED_PYTHON" ]; then
        echo "python: $(python3 --version)"
    else
        echo "Python $INSTALLED found, but $REQUIRED_PYTHON required — installing python$REQUIRED_PYTHON"
        sudo apt install -y python3.10 python3.10-distutils
        sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1
        echo "python: $(python3 --version)"
    fi
else
    sudo apt install -y python3.10 python3.10-distutils
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1
    echo "python: $(python3 --version)"
fi

# Install pip for python3.10 if missing
if ! python3 -m pip --version &> /dev/null; then
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3
fi

# Install Django
if python3 -m django --version &> /dev/null; then
    echo "django: $(python3 -m django --version)"
else
    python3 -m pip install --user django
    echo "django: $(python3 -m django --version)"
fi
