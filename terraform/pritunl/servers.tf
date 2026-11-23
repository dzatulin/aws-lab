resource "pritunl_server" "lab" {
  name     = "aws-lab-vpn"
  network  = "172.27.100.0/24"
  port     = 19649
  protocol = "udp"

  organization_ids = [
    pritunl_organization.lab.id
  ]

  host_ids = [var.pritunl_host_id]
  status   = var.pritunl_server_status

  hash            = "sha256"
  inter_client    = true
  network_mode    = "tunnel"
  restrict_routes = true
  vxlan           = true

  # Preserve client IPs in Common; the Pritunl host manages the AWS return route.
  route {
    network     = "10.10.0.0/16"
    comment     = "common vpc"
    nat         = false
    net_gateway = false
  }

  # Dev returns SNAT traffic through the existing peering route to Common.
  route {
    network     = "10.20.0.0/16"
    comment     = "dev vpc"
    nat         = true
    net_gateway = false
  }
}
