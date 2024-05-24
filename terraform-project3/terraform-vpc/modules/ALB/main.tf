#ALB
resource "aws_lb" "myalb" {
  name               = "asmple-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_ids]
  subnets            = var.subnet_ids

}

#listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.myalb.arn
  port              = "80"
  protocol          = "HTTP"
  

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

#target group

resource "aws_lb_target_group" "tg" {
  name     = "mytg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}


#target group attachment

resource "aws_lb_target_group_attachment" "tga" {
  count = length(var.instances)
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.instances[count.index]
  port             = 80
}
