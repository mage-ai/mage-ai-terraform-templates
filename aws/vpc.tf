# vpc.tf | VPC Configuration
data "aws_vpc" "aws-vpc" {
  id = "vpc-08fc24d82a6b7e3bc"
}


# resource "aws_vpc" "aws-vpc" {
#   cidr_block           = var.cidr
#   enable_dns_hostnames = true
#   enable_dns_support   = true
#   tags = merge(
#     var.common_tags,
#     {
#       Name = "${var.app_name}-vpc"
#     }
#   )
# }
