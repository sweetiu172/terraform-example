resource "aws_vpc_security_group_ingress_rule" "allow_all_traffic_from_http4" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_traffic_from_http6" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv6         = "::/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
###############################################################################################################

resource "aws_security_group" "alb_sg" {
  name        = "${var.alb_name}-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"

  tags = {
    Name = "${var.alb_name}-sg"
  }
}

resource "aws_lb" "hung" {
  name               = var.alb_name
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = ["subnet-0843662aaa665723f", "subnet-0278281770a1cf7f8"]

  enable_deletion_protection = false
}

resource "aws_lb_listener" "hung" {
  load_balancer_arn = aws_lb.hung.arn
  port              = 80
  protocol          = "HTTP"
  

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hung.arn
  }
}

resource "aws_lb_target_group" "hung" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-013608e02dcd26f22"
}
