# --- networking/outputs.tf
output "vpc_id" {
  value = aws_vpc.alt_vpc.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.alt_rds_subnetgroup.*.name
}

output "vpc_security_group_ids" {
  value = [aws_security_group.alt_sg["rds"].id]
}

output "public_sg" {
  value = aws_security_group.alt_sg["public"].id
}

output "public_subnets" {
  value = aws_subnet.alt_public_subnet.*.id
}