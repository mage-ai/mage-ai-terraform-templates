app_name        = "dataeng-mage"
app_environment = "prod"
common_tags = {
  Env       = "prod"
  ManagedBy = "Terraform"
  Owner     = "data-engineering"
  Service   = "mage"
  Repo      = "nursa-com/mage-ai-terraform-templates"
}
docker_image = "015782078654.dkr.ecr.us-west-2.amazonaws.com/dataeng-mage:latest"
