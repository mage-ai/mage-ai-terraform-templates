variable "AWS_ACCESS_KEY_ID" {
  type    = string
  default = "AWS_ACCESS_KEY_ID"
}

variable "AWS_SECRET_ACCESS_KEY" {
  type    = string
  default = "AWS_SECRET_ACCESS_KEY"
}

variable "DATABASE_CONNECTION_URL" {
  type    = string
  default = ""
}

variable "app_count" {
  type    = number
  default = 1
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-west-2"
}

variable "aws_cloudwatch_retention_in_days" {
  type        = number
  description = "AWS CloudWatch Logs Retention in Days"
  default     = 30
}

variable "app_name" {
  type        = string
  description = "Application Name"
  default     = "mage-ai"
}

variable "app_environment" {
  type        = string
  description = "Application Environment"
  default     = "production"
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.32.0.0/16"
}

variable "database_user" {
  type        = string
  description = "The username of the Postgres database."
  default     = "mageuser"
}

variable "database_password" {
  type        = string
  description = "The password of the Postgres database."
  sensitive   = true
}

variable "docker_image" {
  description = "Docker image url used in ECS task."
  # or mageai/mageai:alpha to be on the bleeding edge
  default = "mageai/mageai:latest"
}

variable "ecs_task_cpu" {
  description = "ECS task cpu"
  default     = 4096
}

variable "ecs_task_memory" {
  description = "ECS task memory"
  default     = 8192
}

variable "public_subnets" {
  description = "List of public subnets"
  default     = ["10.32.100.0/24", "10.32.101.0/24"]
}

variable "private_subnets" {
  description = "List of private subnets"
  default     = ["10.32.0.0/24", "10.32.1.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones"
  default     = ["us-west-2a", "us-west-2b"]
}

variable "enable_ci_cd" {
  description = "A flag to enable/disable the CI/CD null resource"
  type        = bool
  default     = false
}
