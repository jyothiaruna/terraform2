resource "aws_security_group" "allow_22_80" {
  name        = "allow_22_80"
  description = "Allow 22 and 80 ports inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.aj_webapp_vpc.id

  tags = {
    Name = "allow_22_80"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_in_22" {
  security_group_id = aws_security_group.allow_22_80.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_in_80" {
  security_group_id = aws_security_group.allow_22_80.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_eg_ipv4" {
  security_group_id = aws_security_group.allow_22_80.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_eg_ipv6" {
  security_group_id = aws_security_group.allow_22_80.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}