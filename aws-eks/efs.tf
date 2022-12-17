# efs.tf | Elastic File System Configuration

resource "aws_efs_file_system" "file_system" {
  encrypted        = true
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"

  tags = {
    Name        = "${var.app_name}-eks-efs"
    Environment = var.app_environment
  }
}

resource "aws_efs_mount_target" "mount_target" {
  count           = length(module.vpc.public_subnets)
  file_system_id  = aws_efs_file_system.file_system.id
  subnet_id       = module.vpc.public_subnets[count.index]
  security_groups = [aws_security_group.mount_target_security_group.id]
}


resource "aws_security_group" "mount_target_security_group" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.app_name}-eks-efs-sg"
    Environment = var.app_environment
  }
}
