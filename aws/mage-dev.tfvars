app_name        = "dataeng-mage"
app_environment = "dev"
common_tags = {
  Env       = "dev"
  ManagedBy = "terraform"
  Owner     = "data-engineering"
  Service   = "mage"
  Repo      = "nursa-com/mage-ai-terraform-templates"
}
docker_image = "015782078654.dkr.ecr.us-west-2.amazonaws.com/dataeng-mage:0bb2a19d54634e3f6dd813f6a4c7f40eeea80ab3"
