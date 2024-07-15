
resource "aws_subnet" "aj_webapp_subnet1a" {
  vpc_id     = aws_vpc.aj_webapp_vpc.id
  cidr_block = "10.10.0.0/24"
  availability_zone = "us-west-1a"
  map_public_ip_on_launch = true
 
  tags = {
    Name = "aj_webapp_subnet1a"
  }
}

resource "aws_subnet" "aj_webapp_subnet2b" {
  vpc_id     = aws_vpc.aj_webapp_vpc.id
  cidr_block = "10.10.1.0/24"
  availability_zone = "us-west-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "aj_webapp_subnet2b"
  }
}

resource "aws_subnet" "aj_webapp_subnet3c" {
  vpc_id     = aws_vpc.aj_webapp_vpc.id
  cidr_block = "10.10.2.0/24"
  availability_zone = "us-west-1b"
  
  tags = {
    Name = "aj_webapp_subnet3c"
  }
}