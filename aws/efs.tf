# efs.tf | Elastic File System Configuration

resource "aws_efs_file_system" "file_system" {
  encrypted        = true
  performance_mode = "generalPurpose"
  throughput_mode  = "elastic"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.app_name}-efs"
    }
  )
}

resource "aws_efs_mount_target" "mount_target" {
  count           = 2 # number of subnets
  file_system_id  = aws_efs_file_system.file_system.id
  subnet_id       = count.index == 0 ? data.aws_subnet.subnet_1.id : data.aws_subnet.subnet_2.id
  security_groups = [aws_security_group.mount_target_security_group.id]
}


resource "aws_security_group" "mount_target_security_group" {
  vpc_id = data.aws_vpc.aws-vpc.id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.service_security_group.id]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.app_name}-efs-sg"
    }
  )
}
