app_name        = "dataeng-mage"
app_environment = "prod"
common_tags = {
  Env       = "prod"
  ManagedBy = "terraform"
  Owner     = "data-engineering"
  Service   = "mage"
  Repo      = "nursa-com/mage-ai-terraform-templates"
}
docker_image                = "015782078654.dkr.ecr.us-west-2.amazonaws.com/dataeng-mage:c4e433e27df77dc2e0acfdc20736998d0e10e9d5"
redshift_cluster_identifier = "nursa-redshift-cluster-1"
redshift_dbname             = "dev"
redshift_user               = "data_team"
redshift_port               = 5439
redshift_host               = "redshift.prod.nursa.internal"
