output "public_subnet" {
  value = aws_subnet.public_subnet.id
}

output "private_subnets" {
  value = [for subnet in aws_subnet.private : subnet.id]
}

output "vpc_id" {
  value = aws_vpc.projeto_tcb.id
}