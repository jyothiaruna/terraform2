
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-1"
}
/* resource "aws_instance" "aruna1-webinstamce3" {
  ami           = "ami-08012c0a9ee8e21c4"
  instance_type = "t2.micro"
  key_name = "terraform2"
  tags = {
    Name = "machine-3"
  }
} */

resource "aws_vpc" "aj_webapp_vpc"{

  cidr_block = "10.10.0.0/16"
  tags = {
    Name = "aj_webapp_vp"
  }

}

resource "aws_key_pair" "terraform_project1" {
  key_name   = "terraform_project1"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAknB2EaaI/s9HfOFdiIbhbg7qdZmXDta7r5Vw+T9/GJ 18582@DESKTOP-DT5LMPU"
}

resource "aws_instance" "web_instance_subnet1a" {
  ami           = "ami-08012c0a9ee8e21c4"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.aj_webapp_subnet1a.id
  key_name = aws_key_pair.terraform_project1.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.allow_22_80.id]
  user_data = filebase64("userdata.sh")

  tags = {
    Name = "aj_machine1"
  }
}

resource "aws_instance" "web_instance_subnet2b" {
  ami           = "ami-08012c0a9ee8e21c4"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.aj_webapp_subnet2b.id
  key_name = aws_key_pair.terraform_project1.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.allow_22_80.id]
  user_data = filebase64("userdata.sh")

  tags = {
    Name = "aj_machine2"
  }
}
