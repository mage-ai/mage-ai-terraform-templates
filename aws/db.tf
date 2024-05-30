# db.tf | Database Configuration

resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "${var.app_name}-${var.app_environment}-rds-subnet-group"
  description = "${var.app_name} RDS subnet group"
  subnet_ids  = [data.aws_subnet.subnet_1.id, data.aws_subnet.subnet_2.id]
  tags = merge(
    var.common_tags,
    {
      Name = "${var.app_name}-${var.app_environment}-rds-subnet-group"
    }
  )
}


resource "aws_security_group" "rds_sg" {
  name        = "${var.app_name}-${var.app_environment}-rds-sg"
  description = "${var.app_name} RDS Security Group"
  vpc_id      = data.aws_vpc.aws-vpc.id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.app_name}-${var.app_environment}-rds-sg"
    }
  )

  // allows traffic from the SG itself
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  //allow traffic for TCP 5432
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = ["${aws_security_group.service_security_group.id}"]
  }

  // outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_secretsmanager_secret" "db_credentials" {
  name = "${var.app_name}/${var.app_environment}/rds-db-creds"
}

data "aws_secretsmanager_secret_version" "latest" {
  secret_id = data.aws_secretsmanager_secret.db_credentials.id
}

resource "aws_db_instance" "rds" {
  identifier             = "${var.app_name}-${var.app_environment}-db"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "13.13"
  instance_class         = "db.t3.micro"
  multi_az               = false
  db_name                = "mage"
  username               = "${jsondecode(data.aws_secretsmanager_secret_version.latest.secret_string)["user"]}"
  password               = "${jsondecode(data.aws_secretsmanager_secret_version.latest.secret_string)["password"]}"
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.id
  vpc_security_group_ids = [aws_security_group.rds_sg.id, aws_security_group.rds_ec2_connect_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.app_name}-${var.app_environment}-db"
    }
  )
}
