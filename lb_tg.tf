resource "aws_lb_target_group" "aj_webapp_lb_targetgroup" {
  name     = "aj-webapp-lb-targetgroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.aj_webapp_vpc.id
}

resource "aws_lb_target_group_attachment" "aj_webapp_lb_tg_attach1" {
  target_group_arn = aws_lb_target_group.aj_webapp_lb_targetgroup.arn
  target_id        = aws_instance.web_instance_subnet1a.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "aj_webapp_lb_tg_attach2" {
  target_group_arn = aws_lb_target_group.aj_webapp_lb_targetgroup.arn
  target_id        = aws_instance.web_instance_subnet2b.id
  port             = 80
}

resource "aws_security_group" "allow_80" {
  name        = "allow_80"
  description = "Allow  80 ports inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.aj_webapp_vpc.id

  tags = {
    Name = "allow_80"
  }
}


resource "aws_vpc_security_group_ingress_rule" "allow_tls_80" {
  security_group_id = aws_security_group.allow_80.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_eg_80" {
  security_group_id = aws_security_group.allow_80.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_eg_80_ipv6" {
  security_group_id = aws_security_group.allow_80.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_lb" "aj_webapp_lb" {
  name               = "aj-webapp-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_80.id]
  subnets            = [aws_subnet.aj_webapp_subnet1a.id,aws_subnet.aj_webapp_subnet2b.id]

  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "aj_webapp_lis" {
  load_balancer_arn = aws_lb.aj_webapp_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aj_webapp_lb_targetgroup.arn
  }
}