output "vpc" {
  value = aws_vpc.this.id
}

output "public" {
  value = [for s in aws_subnet.public : s.id]
}

output "private" {
  value = [for s in aws_subnet.private : s.id]
}
