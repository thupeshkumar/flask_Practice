#!/bin/bash
set -e

# Variables
APP_NAME="flaskapp"
APP_DIR="/var/www/$APP_NAME"
VENV_DIR="$APP_DIR/venv"
REPO_URL="https://github.com/thupeshkumar/flask_Practice.git"
SERVICE_NAME="$APP_NAME.service"

echo "=== Starting Deployment ==="

# Ensure dependencies
sudo apt update
sudo apt install -y python3 python3-venv python3-pip git

# Clone or update repo
if [ ! -d "$APP_DIR" ]; then
    sudo mkdir -p $APP_DIR
    sudo git clone $REPO_URL $APP_DIR
else
    cd $APP_DIR
    sudo git pull origin main
fi

# Setup virtual environment
if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv $VENV_DIR
fi

source $VENV_DIR/bin/activate
pip install --upgrade pip
pip install -r $APP_DIR/requirements.txt

# Create systemd service file
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME"
sudo bash -c "cat > $SERVICE_FILE" <<EOL
[Unit]
Description=Gunicorn instance to serve $APP_NAME
After=network.target

[Service]
User=www-data
Group=www-data
WorkingDirectory=$APP_DIR
Environment="PATH=$VENV_DIR/bin"
ExecStart=$VENV_DIR/bin/gunicorn --workers 3 --bind 0.0.0.0:8000 app:app

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd and restart service
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable $SERVICE_NAME
sudo systemctl restart $SERVICE_NAME

echo "=== Deployment Complete ==="
