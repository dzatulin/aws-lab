resource "pritunl_server" "lab" {
  name     = "aws-lab-vpn"
  network  = "172.27.100.0/24"
  port     = 19649
  protocol = "udp"

  organization_ids = [
    pritunl_organization.lab.id
  ]

  hash            = "sha256"
  inter_client    = true
  network_mode    = "tunnel"
  restrict_routes = true
  vxlan           = true

  route {
    network     = "10.10.0.0/16"
    comment     = "common vpc"
    nat         = false
    net_gateway = false
  }

  route {
    network     = "10.20.0.0/16"
    comment     = "dev vpc"
    nat         = true
    net_gateway = false
  }

  #lifecycle {
  # ignore_changes = [route]
  #}

}
