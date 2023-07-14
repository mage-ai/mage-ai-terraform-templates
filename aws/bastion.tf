# # __generated__ by Terraform
# # Please review these resources and move them into your main configuration files.

resource "aws_security_group" "bastion_sg" {
  description = "security group with ssh port 22 0.0.0.0/0"
  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
  }]
  ingress = [{
    cidr_blocks      = values(local.cidr_blocks)
    description      = ""
    from_port        = 22
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 22
  }]
  name   = "${var.app_name}-${var.app_environment}-bastion-sg"
  vpc_id = data.aws_vpc.aws-vpc.id
  tags = merge(var.common_tags,
    {
      Name = "${var.app_name}-${var.app_environment}-bastion-sg"
    }
  )
}

resource "aws_security_group" "rds_ec2_connect_sg" {
  description = "Security group attached to dataeng-mage-prod-db to allow EC2 instances with specific security groups attached to connect to the database. Modification could lead to connection loss."
  name        = "${var.app_name}-${var.app_environment}-rds-ec2-connect-sg"
  vpc_id      = data.aws_vpc.aws-vpc.id
}

resource "aws_security_group" "rds_bastion_sg" {
  description = "Security group attached to instances to securely connect to dataeng-mage-prod-db. Modification could lead to connection loss."
  name        = "${var.app_name}-${var.app_environment}-rds-bastion-sg"
  vpc_id      = data.aws_vpc.aws-vpc.id
  tags = merge(var.common_tags,
    {
      Name = "${var.app_name}-${var.app_environment}-rds-bastion-sg"
    }
  )
}

resource "aws_security_group_rule" "rds_bastion_sg_ingress" {
  type                     = "ingress"
  description              = "Rule to allow connections from EC2 instances with sg-009b7ae4a245358f2 attached"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_ec2_connect_sg.id
  source_security_group_id = aws_security_group.rds_bastion_sg.id
}

resource "aws_security_group_rule" "rds_bastion_sg_egress" {
  type                     = "egress"
  description              = "Rule to allow connections to dataeng-mage-prod-db from any instances this security group is attached to"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_bastion_sg.id
  source_security_group_id = aws_security_group.rds_ec2_connect_sg.id
}

resource "aws_instance" "bastion" {
  ami               = "ami-0507f77897697c4ba"
  instance_type     = "t2.micro"
  availability_zone = "us-west-2a"
  key_name = "dataeng-mage-bastion"
  tags = merge(var.common_tags,
    {
      Name = "dataeng-mage-prod-bastion"
    }
  )
  vpc_security_group_ids = [aws_security_group.rds_bastion_sg.id, aws_security_group.bastion_sg.id]
  subnet_id              = data.aws_subnet.subnet_1.id
}
