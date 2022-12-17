variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-west-2"
}

variable "app_name" {
  type        = string
  description = "Application Name"
  default     = "mage-data-prep"
}

variable "app_environment" {
  type        = string
  description = "Application Environment"
  default     = "production"
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnets"
  default     = ["10.0.100.0/24", "10.0.101.0/24"]
}

variable "private_subnets" {
  description = "List of private subnets"
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}
