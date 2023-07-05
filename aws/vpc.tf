# vpc.tf | VPC Configuration

resource "aws_vpc" "aws-vpc" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(
    var.common_tags,
    {
      Name = "${var.app_name}-vpc"
    }
  )
}
