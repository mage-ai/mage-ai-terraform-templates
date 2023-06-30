# mage-ai-terraform-templates
Terraform templates for deploying mage-ai to AWS, GCP and Azure

## Steps for Deploying

We use the aws scripts for deploying to all commands should be ran in the `aws` directory. We have variables set for prod in `mage-prod.tfvars`. You must use this file in your terraform commands or it will completely destroy and redeploy everything.

```
cd aws
terraform plan -var-file="mage-prod.tfvars" # check for changes, especially destroys!
terraform apply -var-file="mage-prod.tfvars" # applies changes listed in the plan
```

> IMPORTANT NOTE: It is very important to check your changes with `terraform plan -var-file="mage-prod.tfvars"` first. This will tell you if terraform needs to destroy any existing resources. Currently if it destorys the RDS database or even the ECS cluster it will be a complete reset of all of our config and user settings. We should not need to deploy this infra very often. In the future we will make changes to allow us to restore configs if we ever do need to do a complete redeploy. 

After checking the infra deltas with `terraform plan -var-file="mage-prod.tfvars"` then run `terraform apply -var-file="mage-prod.tfvars"` to make the changes. This will confirm the plan with you. You will need to type in `yes` to continue. 

