# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# This is the configuration for Terragrunt, a thin wrapper for Terraform that supports locking and enforces best
# practices: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # source = "../../../../../mage-ai-terraform-templates/aws-private-existing-vpc//module"
  source = ".//module"
}

# Uncomment if adding to an existing Terragrunt configuration
# Include all settings from the root terragrunt.hcl file
# include {
#   path = find_in_parent_folders()
# }

locals {}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
# ---------------------------------------------------------------------------------------------------------------------

inputs = {
  aws_region           = "us-west-2"

  # Network
  allowed_cidr_blocks   = ["YOUR_PRIVATE_CIDR/32", "YOUR_VPN_CIDR/32"]
  subnet_name           = "private"

  # ECS resources
  ecs_task_cpu          = 512
  ecs_task_memory       = 1024

  # Base image
  docker_image          = "mageai/mageai:latest"
}
