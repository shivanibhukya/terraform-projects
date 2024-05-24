output "vpc_id" {
  value = aws_vpc.myvpc.id
}

output "subnet_ids" {
  value = aws_subnet.pub-sub.*.id
}