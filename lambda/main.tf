data "archive_file" "sample_function" {
  type        = "zip"
  source_dir  = "./src"
  output_path = "./output/lambda_function.zip"
}
resource "aws_lambda_function" "test_function" {
  filename         = data.archive_file.sample_function.output_path
  function_name    = "test_function"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.sample_function.output_base64sha256
  runtime          = "python3.8"
  memory_size = 128
  timeout     = 30
}
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
