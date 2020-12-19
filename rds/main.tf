# RDS
resource "aws_db_subnet_group" "praivate-db" {
    name        = "praivate-db"
    subnet_ids  = ["${aws_subnet.private-db1.id}", "${aws_subnet.private-db2.id}"]
    tags = {
        Name = "praivate-db"
    }
}

resource "aws_db_instance" "test-db" {
  identifier           = "test-db"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "11.5"
  instance_class       = "db.t3.micro"
  name                 = "testdb"
  username             = "test"
  password             = "test"
  skip_final_snapshot = true
}