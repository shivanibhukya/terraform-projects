resource "aws_vpc" "sample-vpc" {
  cidr_block = var.cidr

  tags = {
    name = "sample-vpc"
  }
}

resource "aws_subnet" "pub-sub1" {
  vpc_id = aws_vpc.sample-vpc.id
  availability_zone = "us-east-1a"
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    name = "pubsub1"
  }
}
resource "aws_subnet" "pub-sub2" {
  vpc_id = aws_vpc.sample-vpc.id
  availability_zone = "us-east-1b"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    name = "pubsub2"
  }
}

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.sample-vpc.id

  tags = {
    name = "sample-igw"
  }
}

resource "aws_route_table" "myrt" {
  vpc_id = aws_vpc.sample-vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }

  tags = {
    name = "sample-rt"
  }
}

resource "aws_route_table_association" "myrtas1" {
  subnet_id = aws_subnet.pub-sub1.id
  route_table_id = aws_route_table.myrt.id
}

resource "aws_route_table_association" "myrtas2" {
  subnet_id = aws_subnet.pub-sub2.id
  route_table_id = aws_route_table.myrt.id
}

resource "aws_security_group" "sg" {
  name = "mysg"
  vpc_id = aws_vpc.sample-vpc.id

    ingress  {
        description = "allow http"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress  {
        description = "allow ssh"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        description = "allow from everyone"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_s3_bucket" "mybucket" {
  bucket = "samplebucketforproject"
}

resource "aws_instance" "web1" {
  ami = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id = aws_subnet.pub-sub1.id
  user_data = base64encode(file("userdata1.sh"))

  tags = {
    name = "webserver1"
  }
}

resource "aws_instance" "web2" {
  ami = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id = aws_subnet.pub-sub2.id
  user_data = base64encode(file("userdata2.sh"))

  tags = {
    name = "webserver2"
  }

}

#create lb

resource "aws_lb" "lb" {
  name = "sample-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.sg.id]
  subnets = [aws_subnet.pub-sub1.id,aws_subnet.pub-sub2.id]
}

resource "aws_lb_target_group" "tg" {
  name = "sample-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.sample-vpc.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "attachement1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id = aws_instance.web1.id
  port = 80
}

resource "aws_lb_target_group_attachment" "attachement2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id = aws_instance.web2.id
  port = 80
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.lb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type = "forward"
  }
}

output "lb-arn" {
  value = aws_lb.lb.dns_name
}



