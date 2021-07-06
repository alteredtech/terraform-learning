# --- loadbalancer/outputs.tf
output "lb_target_group_arn" {
  value = aws_lb_target_group.alt_tg.arn
}

output "lb_endpoint" {
  value = aws_lb.alt_lb.dns_name
}