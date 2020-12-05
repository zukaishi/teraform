resource "aws_instance" "web1" {
    ami           = "ami-f80e0596"
    instance_type = "t2.micro"
    monitoring    = true
    tags {
        Name = "web1"
    }
}
