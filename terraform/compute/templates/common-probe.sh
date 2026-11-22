#!/bin/bash
set -euo pipefail

mkdir -p /opt/aws-lab-probe

cat > /opt/aws-lab-probe/server.py <<'PY'
from http.server import BaseHTTPRequestHandler, HTTPServer


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        client_ip = self.client_address[0]

        body = (
            "AWS Lab Common VPC OK\n"
            f"source_ip={client_ip}\n"
        ).encode()

        self.send_response(200)
        self.send_header("Content-Type", "text/plain")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)


HTTPServer(("0.0.0.0", 8080), Handler).serve_forever()
PY

cat > /etc/systemd/system/aws-lab-probe.service <<'EOF'
[Unit]
Description=AWS Lab Network Probe
After=network.target

[Service]
ExecStart=/usr/bin/python3 /opt/aws-lab-probe/server.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now aws-lab-probe
