#!/bin/bash
set -euo pipefail

mkdir -p /opt/aws-lab-http

echo "AWS Lab DEV VPC OK" > /opt/aws-lab-http/index.html

cat > /etc/systemd/system/aws-lab-http.service <<'EOF'
[Unit]
Description=AWS Lab HTTP Test Server
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 -m http.server 8080 --bind 0.0.0.0 --directory /opt/aws-lab-http
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now aws-lab-http
