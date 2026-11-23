variable "pritunl_api_token" {
  type      = string
  sensitive = true
}

variable "pritunl_api_secret" {
  type      = string
  sensitive = true
}

variable "pritunl_host_id" {
  description = "Pritunl Host ID from pritunl get-host-id, not the AWS instance ID."
  type        = string

  validation {
    condition     = length(trimspace(var.pritunl_host_id)) > 0 && !startswith(var.pritunl_host_id, "i-")
    error_message = "Provide a non-empty Pritunl Host ID, not an EC2 instance ID."
  }
}

variable "pritunl_server_status" {
  description = "Explicit desired VPN server status: offline for initial setup, online after advertisement is configured."
  type        = string

  validation {
    condition     = contains(["offline", "online"], var.pritunl_server_status)
    error_message = "VPN server status must be offline or online."
  }
}

variable "pritunl_user_email" {
  description = "Lab user email; supply locally, never hard-code personal contact details."
  type        = string
  sensitive   = true

  validation {
    condition     = can(regex("^[^@ ]+@[^@ ]+[.][^@ ]+$", var.pritunl_user_email))
    error_message = "Provide a valid lab user email address."
  }
}
