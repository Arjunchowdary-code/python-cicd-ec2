#!/bin/bash
set -e

apt-get update -y
apt-get install -y python3-venv python3-pip

cd /opt/pythonapp

python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# systemd service
cat >/etc/systemd/system/pythonapp.service <<'EOF'
[Unit]
Description=Python Flask App
After=network.target

[Service]
WorkingDirectory=/opt/pythonapp
Environment="PORT=8000"
ExecStart=/opt/pythonapp/venv/bin/gunicorn -b 0.0.0.0:8000 app:app
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable pythonapp.service
