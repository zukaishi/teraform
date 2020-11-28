resource "aws_s3_bucket" "b" {
  bucket = "zukaishi-tf-test-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_object" "folder1" {
    bucket = "zukaishi-tf-test-bucket"
    acl    = "private"
    key    = "Folder1/test.txt"
}