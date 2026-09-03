#!/bin/bash
set -e

APP_NAME="flaskapp"
APP_DIR="/var/www/$APP_NAME"
VENV_DIR="$APP_DIR/venv"
REPO_URL="https://github.com/thupeshkumar/flask_Practice.git"
SERVICE_NAME="$APP_NAME.service"

echo "=== Starting Deployment ==="

# Ensure dependencies
apt update
apt install -y python3 python3-venv python3-pip git

# Clone or update repo
if [ ! -d "$APP_DIR" ]; then
    mkdir -p $APP_DIR
    git clone $REPO_URL $APP_DIR
else
    cd $APP_DIR
    git pull origin main
fi

# Setup virtual environment
if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv $VENV_DIR
fi

$VENV_DIR/bin/pip install --upgrade pip
$VENV_DIR/bin/pip install -r $APP_DIR/requirements.txt

# Create systemd service file
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME"
cat > $SERVICE_FILE <<EOL
[Unit]
Description=Gunicorn instance to serve $APP_NAME
After=network.target

[Service]
User=jenkins
Group=jenkins
WorkingDirectory=$APP_DIR
Environment="PATH=$VENV_DIR/bin"
ExecStart=$VENV_DIR/bin/gunicorn --workers 3 --bind 0.0.0.0:8000 app:app

[Install]
WantedBy=multi-user.target
EOL

systemctl daemon-reexec
systemctl daemon-reload
systemctl enable $SERVICE_NAME
systemctl restart $SERVICE_NAME

echo "=== Deployment Complete ==="
