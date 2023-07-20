output "mage_ai_lb_dns_name" {
  value = "MageAI URL: ${aws_alb.application_load_balancer.dns_name}"
}