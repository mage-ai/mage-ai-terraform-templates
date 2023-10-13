variable "DATABASE_CONNECTION_URL" {
  type    = string
  default = ""
}

variable "app_count" {
  type = number
  default = 1
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "aws_cloudwatch_retention_in_days" {
  type        = number
  description = "AWS CloudWatch Logs Retention in Days"
  default     = 30
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
  default     = "mageai/mageai:latest"
}

variable "ecs_task_cpu" {
  description = "ECS task cpu"
  default = 512
}

variable "ecs_task_memory" {
  description = "ECS task memory"
  default = 1024
}

variable "subnet_name" {
  type = string
  description = "Name of the subnet to deploy MageAI"
  default = "private"
}

variable "allowed_cidr_blocks" {
  type = list(string)
  description = "List of CIDR blocks to allow access to the ECS service"
}
