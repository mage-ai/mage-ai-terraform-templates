# db.tf | Database Configuration

resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "${var.app_name}-${var.app_environment}-rds-subnet-group"
  description = "${var.app_name} RDS subnet group"
  subnet_ids  = aws_subnet.public.*.id
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

resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "${var.app_name}/${var.app_environment}/rds-db-creds"
  description = "Mage RDS Database credentials"
  tags = merge(
    var.common_tags,
    {
      Name = "${var.app_name}-${var.app_environment}-rds-db-creds"
    }
  )
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    "user" = "${var.database_user}"
    "password"  = "${var.database_password}"
  })
}

resource "aws_db_instance" "rds" {
  identifier             = "${var.app_name}-${var.app_environment}-db"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "13.10"
  instance_class         = "db.t3.micro"
  multi_az               = false
  db_name                = "mage"
  username               = var.database_user
  password               = var.database_password
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.id
  vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
  skip_final_snapshot    = true
  publicly_accessible    = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.app_name}-${var.app_environment}-db"
    }
  )
}
