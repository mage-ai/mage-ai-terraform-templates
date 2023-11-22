app_name        = "dataeng-mage"
app_environment = "prod"
common_tags = {
  Env       = "prod"
  ManagedBy = "terraform"
  Owner     = "data-engineering"
  Service   = "mage"
  Repo      = "nursa-com/mage-ai-terraform-templates"
}
docker_image = "015782078654.dkr.ecr.us-west-2.amazonaws.com/dataeng-mage:7904b0f9467fae3d2ccad5717c29870fdd98178f"
