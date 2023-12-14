# mage-ai-terraform-templates
Terraform templates for deploying mage-ai to AWS, GCP and Azure

> NOTE: We currently only use the AWS deployment templates in the `aws/` folder.

## Steps for Deploying

We use the aws scripts for deploying to all commands should be ran in the `aws` directory. We have variables set for prod in `mage-prod.tfvars`. You must use this file in your terraform commands or it will completely destroy and redeploy everything.

```
cd aws
terraform plan -var-file="mage-prod.tfvars" # check for changes, especially destroys!
terraform apply -var-file="mage-prod.tfvars" # applies changes listed in the plan
```

> IMPORTANT NOTE: It is very important to check your changes with `terraform plan -var-file="mage-prod.tfvars"` first. This will tell you if terraform needs to destroy any existing resources. Currently if it destorys the RDS database or even the ECS cluster it will be a complete reset of all of our config and user settings. We should not need to deploy this infra very often. In the future we will make changes to allow us to restore configs if we ever do need to do a complete redeploy. 

After checking the infra deltas with `terraform plan -var-file="mage-prod.tfvars"` then run `terraform apply -var-file="mage-prod.tfvars"` to make the changes. This will confirm the plan with you. You will need to type in `yes` to continue. 

## Dependencies

There are some dependencies on existing AWS infrastructure. If we were to lose any of these existing resources in AWS defined in the `data` blocks in the code, we would need to deploy new ones and update the references. This list isn't gauranteed to be exhaustive:

1. `aws_vpc.aws-vpc`
2. `aws_subnet.subnet_1`
3. `aws_subnet.subnet_2`
4. `aws_route53_zone.nursa_dataeng` 
5. `aws_acm_certificate.cert`

There are other resources that need to be created before deploying if they don't exist including:

1. Mage project docker image in ECR `var.docker_image`

