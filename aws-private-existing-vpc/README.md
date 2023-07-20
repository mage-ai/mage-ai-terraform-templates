# MageAI in AWS
This module deploys MageAI and is built off the `aws` module, however, it makes the following assumptions:
* MageAI will be added to an existing VPC
* Deployment should be to private subnets
* The control database should not be publicly accessible
* Your deployment has a VPN for accessing resources on the private subnet.

## Pre-Deployment
Before deployment, you will need to ensure you have the following installed:
* [Terragrunt](https://terragrunt.gruntwork.io/)
* [Terraform](https://www.terraform.io/)

The module also expects you to have an existing AWS environment with the following:
* VPC

And you have set up your AWS CLI credentials to be used in Terragrunt deployment:
* [Creating AN AWS Account for Programmatic Access](https://dev.to/ladvien/creating-an-aws-account-for-programmatic-access-57ng)

If you need to create a Terragrunt project, this article explains the setup:
* [How to Set Up Terraform and Terragrunt](https://dev.to/ladvien/how-to-set-up-terraform-and-terragrunt-22p)

## Deployment
1. Add the `module` folder to your existing Terragrunt modules directory. Rename it `mageai`
2. Enter your Terragrunt environment folder and create a folder called `mageai`
3. Create a `terragrunt.hcl` similar to the one contained in this project folder.
4. Set the `allowed_cidr_blocks` to an array of CIDR blocks that should have access to the MageAI UI
5. Set the subnet name to the approximate name of your private subnet
6. Adjust other settings as necessary
7. From the terminal, run `terragrunt plan` within the same folder as your `terragrunt.hcl` file.
8. Review the deployment plan
9. If the deployment plan appears correct, run `terragrunt deploy` and accept the deployment by typing `yes`.
10. After deployment, the terminal should print out the URL where the MageAI application can be accessed.

