# alb.tf | Load Balancer Configuration

resource "aws_alb" "application_load_balancer" {
  name               = "${var.app_name}-${var.app_environment}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public.*.id
  security_groups    = [aws_security_group.load_balancer_security_group.id]

  tags = merge(
    var.common_tags,
    {
      Name = "${var.app_name}-alb"
    }
  )
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "load_balancer_security_group" {
  vpc_id = data.aws_vpc.aws-vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "dataeng team ips"
    cidr_blocks = [
      "50.168.68.90/32", # office
      "76.140.96.213/32",
      "67.2.180.194/32",
      "73.63.25.63/32"
    ]

  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "dataeng team ips"
    cidr_blocks = [
      "50.168.68.90/32", # office
      "76.140.96.213/32",
      "67.2.180.194/32",
      "73.63.25.63/32"
    ]
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
      Name = "${var.app_name}-sg"
    }
  )
}

resource "aws_lb_target_group" "target_group" {
  name        = "${var.app_name}-${var.app_environment}-tg"
  port        = 6789
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.aws-vpc.id

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "5"
    path                = "/api/kernels"
    unhealthy_threshold = "2"
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.app_name}-lb-tg"
    }
  )
}

data "aws_acm_certificate" "cert" {
  domain      = "nursa-dataeng.com"
  statuses    = ["ISSUED"]
  most_recent = true
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_alb.application_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.app_name}-lb-http_listener"
    }
  )

  depends_on = [aws_lb_listener.https_listener]

}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_alb.application_load_balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = data.aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.app_name}-lb-https_listener"
    }
  )
}

data "aws_route53_zone" "nursa_dataeng" {
  name = "nursa-dataeng.com"
}

resource "aws_route53_record" "mage_record" {
  zone_id = data.aws_route53_zone.nursa_dataeng.zone_id
  name    = "mage.nursa-dataeng.com"
  type    = "A"

  alias {
    name                   = aws_alb.application_load_balancer.dns_name
    zone_id                = aws_alb.application_load_balancer.zone_id
    evaluate_target_health = false
  }
}
