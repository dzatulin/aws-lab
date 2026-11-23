terraform {
  required_version = ">= 1.13.0"

  required_providers {
    pritunl = {
      source  = "disc/pritunl"
      version = "0.8.8"
    }
  }
}

provider "pritunl" {
  url      = "https://localhost:8443"
  token    = var.pritunl_api_token
  secret   = var.pritunl_api_secret

  # Self-signed certificate over SSM tunnel
  insecure = true
}
