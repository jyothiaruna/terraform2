resource "aws_launch_template" "aj_webapp_asg_launch_template" {
  name = "aj_webapp_asg_launch_template"
   
  image_id = "ami-08012c0a9ee8e21c4"

  instance_type = "t2.micro"

  key_name = aws_key_pair.terraform_project1.id

  vpc_security_group_ids = [aws_security_group.allow_22_80.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "aj_webapp_asg"
    }
  }

  user_data = filebase64("userdata.sh")
}

#TG

resource "aws_lb_target_group" "aj_webapp_lb_targetgroup2" {
  name     = "aj-webapp-lb-targetgroup2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.aj_webapp_vpc.id
}

resource "aws_autoscaling_group" "aj_webapp_asg" {
  vpc_zone_identifier = [aws_subnet.aj_webapp_subnet1a.id, aws_subnet.aj_webapp_subnet2b.id]
  desired_capacity   = 2
  max_size           = 5
  min_size           = 2
  target_group_arns = [aws_lb_target_group.aj_webapp_lb_targetgroup2.arn]
  launch_template {
    id      = aws_launch_template.aj_webapp_asg_launch_template.id
    version = "$Latest"
  }
}


resource "aws_lb" "aj_webapp_lb2" {
  name               = "aj-webapp-lb2"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_80.id]
  subnets            = [aws_subnet.aj_webapp_subnet1a.id,aws_subnet.aj_webapp_subnet2b.id]

  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "aj_webapp_lis2" {
  load_balancer_arn = aws_lb.aj_webapp_lb2.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aj_webapp_lb_targetgroup2.arn
  }
}