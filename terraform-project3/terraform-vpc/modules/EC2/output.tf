output "instance_ids" {
  value = aws_instance.myec2.*.id
}