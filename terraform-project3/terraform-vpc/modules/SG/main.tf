resource "aws_security_group" "mysg" {
  name        = "sample-sg"
  description = "Allow http traffic"
  vpc_id      = var.vpc_id


  ingress  {
      description = "allow HTTP traffic"
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress  {
      description = "allow ssh traffic"
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
   
  egress  {
      description = "allow HTTP traffic"
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sample-sg"
  }

}




