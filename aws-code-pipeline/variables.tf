variable "AWS_ACCESS_KEY_ID" {
  type = string
  default = "AWS_ACCESS_KEY_ID"
}

variable "AWS_SECRET_ACCESS_KEY" {
  type = string
  default = "AWS_SECRET_ACCESS_KEY"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-west-2"
}

variable "aws_account_id" {
  type        = string
  description = "AWS Account ID"
  default     = "123456789012"
}

variable "s3_bucket_name" {
  type = string
  description = "S3 bucket to store pipeline artifacts"
  default = "s3-bucket-name"
}

variable "code_pipeline_name" {
    type = string
    description = "Name for AWS CodePipeline"
    default = "mage-codepipeline"
}

variable "ecr_image_tag" {
  type        = string
  description = "ECR docker image tag"
  default     = "latest"
}

variable "ecr_repo_name" {
  type        = string
  description = "ECR repo name"
  default     = "ecr-repo-name"
}

variable "ecs_cluster_name" {
  type        = string
  description = "ECS cluster name"
  default     = "ecs-cluster-name"
}

variable "ecs_service_name" {
  type        = string
  description = "ECS service name"
  default     = "ecs-service-name"
}

variable "codecommit_repo_name" {
  type        = string
  description = "Codecommit repo name"
  default     = "codecommit-repo-name"
}

variable "codecommit_branch" {
  type        = string
  description = "Codecommit repo branch"
  default     = "main"
}