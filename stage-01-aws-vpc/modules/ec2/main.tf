resource "aws_key_pair" "main" {
  key_name   = "${var.project_name}-${var.environment}-key"
  public_key = file(var.public_key_path)
  tags = { Name = "${var.project_name}-${var.environment}-key" }
}

resource "aws_instance" "app" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.app_sg_id]
  key_name                    = aws_key_pair.main.key_name

  user_data = base64encode(<<-USERDATA
#!/bin/bash
exec > /var/log/userdata.log 2>&1
set -x
mkdir -p /app
cat > /app/server.py << 'PYEOF'
import json
import socket
from http.server import HTTPServer, BaseHTTPRequestHandler
from datetime import datetime

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.end_headers()
        response = json.dumps({
            "message": "CloudWatch Pro - Weather API",
            "hostname": socket.gethostname(),
            "timestamp": datetime.utcnow().isoformat(),
            "status": "healthy"
        })
        self.wfile.write(response.encode())
    def log_message(self, format, *args):
        pass

print("Starting server on port 3000")
HTTPServer(('0.0.0.0', 3000), Handler).serve_forever()
PYEOF
nohup python3 /app/server.py > /var/log/app.log 2>&1 &
echo "Server started"
  USERDATA
  )

  tags = { Name = "${var.project_name}-${var.environment}-app" }
}
