data aws_ssm_parameter amzn2_ami {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource aws_instance demo {
  ami = data.aws_ssm_parameter.amzn2_ami.value
  instance_type = "t2.micro"
}