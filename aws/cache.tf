
# This file contains the configuration for the Redis cluster

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "${var.app_name}-${var.app_environment}-redis-subnet-group"
  subnet_ids = [data.aws_subnet.subnet_1.id, data.aws_subnet.subnet_2.id]

  tags = merge(
    var.common_tags,
    {
      Name = "${var.app_name}-${var.app_environment}-redis-subnet-group"
    }
  )
}

resource "aws_security_group" "redis_security_group" {
  name        = "${var.app_name}-${var.app_environment}-redis-sg"
  description = "Security group for Redis Cluster"
  vpc_id = data.aws_vpc.aws-vpc.id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.service_security_group.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.app_name}-redis-sg"
    }
  )
}

resource "aws_elasticache_cluster" "redis_cluster" {
  cluster_id        = "${var.app_name}-${var.app_environment}-redis-cluster"
  engine            = "redis"
  node_type         = "cache.t3.micro"
  num_cache_nodes   = 1
  engine_version    = "7.1"
  port              = 6379
  subnet_group_name = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids = [aws_security_group.redis_security_group.id]
  apply_immediately = true
  tags = merge(
    var.common_tags,
    {
      Name = "${var.app_name}-${var.app_environment}-redis-cluster"
  })
}

output "redis_endpoint" {
  value = aws_elasticache_cluster.redis_cluster.cache_nodes.0.address
}