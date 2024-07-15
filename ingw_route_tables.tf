resource "aws_internet_gateway" "aj_webapp_igw" {
  vpc_id = aws_vpc.aj_webapp_vpc.id

  tags = {
    Name = "aj_webapp_igw"
  }
}

resource "aws_route_table" "aj_webapp_routetable1" {
  vpc_id = aws_vpc.aj_webapp_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aj_webapp_igw.id
  }

  tags = {
    Name = "aj_webapp_routetable1"
  }
}


resource "aws_route_table" "aj_webapp_routetable2_private" {
  vpc_id = aws_vpc.aj_webapp_vpc.id

  tags = {
    Name = "aj_webapp_routetable2_private"
  }
}

resource "aws_route_table_association" "aj_webapp_rt_as_public_s1" {
  subnet_id      = aws_subnet.aj_webapp_subnet1a.id
  route_table_id = aws_route_table.aj_webapp_routetable1.id
}

resource "aws_route_table_association" "aj_webapp_rt_as_public_s2" {
  subnet_id      = aws_subnet.aj_webapp_subnet2b.id
  route_table_id = aws_route_table.aj_webapp_routetable1.id
}

resource "aws_route_table_association" "aj_webapp_rt_as_private_s3" {
  subnet_id      = aws_subnet.aj_webapp_subnet3c.id
  route_table_id = aws_route_table.aj_webapp_routetable2_private.id
}