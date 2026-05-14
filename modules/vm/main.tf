resource "azurerm_public_ip" "main" {
  name                = "${var.project_name}-${var.environment}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "main" {
  name                = "${var.project_name}-${var.environment}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                = "${var.project_name}-${var.environment}-vm"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = "Standard_D2s_v3"
  admin_username      = "azureuser"

  network_interface_ids = [azurerm_network_interface.main.id]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file(var.public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  custom_data = base64encode(<<-USERDATA
#!/bin/bash
apt-get update -y
mkdir -p /app
cat > /app/server.py << 'PYEOF'
import json, socket
from http.server import HTTPServer, BaseHTTPRequestHandler
from datetime import datetime
class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-Type','application/json')
        self.end_headers()
        self.wfile.write(json.dumps({"message":"CloudWatch Pro - Azure API","hostname":socket.gethostname(),"timestamp":datetime.utcnow().isoformat(),"cloud":"Azure","status":"healthy"}).encode())
    def log_message(self,f,*a): pass
HTTPServer(('0.0.0.0',3000),Handler).serve_forever()
PYEOF
nohup python3 /app/server.py > /var/log/app.log 2>&1 &
  USERDATA
  )
}
