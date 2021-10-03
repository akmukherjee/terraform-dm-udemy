# --- networking/outputs.tf
output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "db_subnet_name" {
  value = aws_db_subnet_group.mtc-rds-subnet-group.*.name
}

output "db_security_group_ids" {
  value = [aws_security_group.mtc-sg["rds"].id]
}

output "public_sg" {
  value = [aws_security_group.mtc-sg["public"].id]
}

output "public_subnets" {
  value = aws_subnet.public_subnet.*.id
}