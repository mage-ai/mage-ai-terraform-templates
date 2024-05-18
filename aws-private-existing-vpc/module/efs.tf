# efs.tf | Elastic File System Configuration

resource "aws_efs_file_system" "file_system" {
  encrypted         = true
  performance_mode  = "generalPurpose"
  throughput_mode   = "elastic"

  tags = {
    Name        = "${var.app_name}-efs"
    Environment = var.app_environment
  }
}

resource "aws_efs_mount_target" "mount_target" {
  count = length(data.aws_subnets.subnets.ids)
  file_system_id = aws_efs_file_system.file_system.id
  subnet_id      = data.aws_subnets.subnets.ids[count.index]
  security_groups = [ aws_security_group.mount_target_security_group.id ]
}


resource "aws_security_group" "mount_target_security_group" {
  vpc_id = data.aws_vpc.selected.id

  ingress {
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    security_groups  = [aws_security_group.service_security_group.id]
  }

  tags = {
    Name        = "${var.app_name}-efs-sg"
    Environment = var.app_environment
  }
}
