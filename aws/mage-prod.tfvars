app_name        = "dataeng-mage"
app_environment = "prod"
common_tags = {
  Env       = "prod"
  ManagedBy = "Terraform"
  Owner     = "data-engineering"
  Service   = "mage"
  Repo      = "nursa-com/mage-ai-terraform-templates"
}
whitelist_cidr_blocks = [
      "50.168.68.90/32", # Office
      "76.140.96.213/32",# Adam Home
      "67.2.180.194/32", # Ethan Home
      "73.63.25.63/32"   # Nate Home
]
