variable "client_id" {}
variable "client_secret" {}

variable "agent_count" {
  default = 1
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
  default = "tonedefdev-k8s"
}

variable cluster_name {
  default = "tonedefdev-k8s"
}

variable rg_name {
  default = "tonedefdev-k8s"
}

variable location {
  default = "Central US"
}

variable log_analytics_workspace_name {
  default = "tonedefdev-k8s-workspace"
}

variable log_analytics_workspace_location {
  default = "eastus"
}
 
variable log_analytics_workspace_sku {
  default = "PerGB2018"
}