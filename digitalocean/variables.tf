variable "app_environment" {
  type        = string
  description = "Application Environment"
  default     = "production"
}

variable "app_name" {
  type        = string
  description = "Application Name"
  default     = "mage-data-prep"
}

variable "cpu" {
  description = "Instance CPU"
  default     = "1"
}

variable "memory" {
  description = "Instance memory in GB"
  default     = "1"
}

variable "region" {
  type        = string
  description = "Region of the datacenters"
  default     = "sfo3"
}


variable "ssh_pub_key" {
  description = "Path to SSH public key"
  default     = "~/.ssh/id_rsa.pub"
}
