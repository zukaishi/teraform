# VPC
resource "aws_vpc" "workspace" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "workspace"
  }
}

# Subnet
resource "aws_subnet" "workspace" {
  vpc_id = "${aws_vpc.workspace.id}"
  availability_zone = "ap-northeast-1a"
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "workspace-public-1a"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "workspace" {
  vpc_id = "${aws_vpc.workspace.id}"
  tags = {
    Name = "workspace"
  }
}

# Security Group
resource "aws_security_group" "workspace" {
  vpc_id = aws_vpc.workspace.id
  name   = "workspace"

  tags = {
    Name = "workspace"
  }
}

# AMI
data "aws_ami" "workspace" {
  most_recent = true
  owners = ["amazon"]

  filter { 
    name = "architecture"
    values = ["x86_64"]
  }

  filter { 
    name = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# EC2
resource "aws_instance" "workspace" {
  ami                    = data.aws_ami.workspace.image_id
  vpc_security_group_ids = [aws_security_group.workspace.id]
  subnet_id              = aws_subnet.workspace.id
  key_name               = aws_key_pair.workspace.id
  instance_type          = "t2.micro"

  tags = {
    Name = "workspace"
  }
}

# Elastic IP
resource "aws_eip" "workspace" {
  instance = aws_instance.workspace.id
  vpc = true
}

# Key Pair
resource "aws_key_pair" "workspace" {
  key_name   = "workspace"
  public_key = file("./workspace.pub") # 先程`ssh-keygen`コマンドで作成した公開鍵を指定
}