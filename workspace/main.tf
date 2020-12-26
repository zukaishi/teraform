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
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
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
  public_key = file("./workspace.pub")
}

# VPC
resource "aws_vpc" "workspace" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "workspace"
  }
}

# Subnet
resource "aws_subnet" "workspace" {
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
  vpc_id = aws_vpc.workspace.id

  map_public_ip_on_launch = true
  tags = {
    Name = "workspace"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "workspace" {
  vpc_id = aws_vpc.workspace.id

  tags = {
    Name = "workspace"
  }
}

# Route Table
resource "aws_route_table" "workspace" {
  vpc_id = aws_vpc.workspace.id

  tags = {
    Name = "workspace"
  }
}

resource "aws_route" "workspace" {
  gateway_id             = aws_internet_gateway.workspace.id
  route_table_id         = aws_route_table.workspace.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "workspace" {
  subnet_id      = aws_subnet.workspace.id
  route_table_id = aws_route_table.workspace.id
}

# Security Group
resource "aws_security_group" "workspace" {
  vpc_id = aws_vpc.workspace.id
  name   = "workspace"

  tags = {
    Name = "workspace"
  }
}

# インバウンドルール(ssh接続用)
resource "aws_security_group_rule" "in_ssh" {
  security_group_id = aws_security_group.workspace.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}

# インバウンドルール(pingコマンド用)
resource "aws_security_group_rule" "in_icmp" {
  security_group_id = aws_security_group.workspace.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
}

# アウトバウンドルール(全開放)
resource "aws_security_group_rule" "out_all" {
  security_group_id = aws_security_group.workspace.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}

# output
output "public_ip" {
  value = aws_eip.workspace.public_ip
}