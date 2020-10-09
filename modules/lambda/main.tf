provider "aws" {
  region = "us-east-1"
}

###################
# Get Lambda
###################
resource "aws_lambda_function" "get" {
   function_name = "get-${var.environment}"

   # The bucket name as created earlier with "aws s3api create-bucket"
   s3_bucket = var.s3_bucket
   s3_key    = "v1.0.0/get.zip"

   # "main" is the filename within the zip file (main.js) and "handler"
   # is the name of the property under which the handler function was
   # exported in that file.
   handler = "main.handler"
   runtime = "nodejs12.x"

   role = aws_iam_role.lambda_exec.arn

   environment {
    variables = {
      GAMES_TABLE = var.table_name
    }
  }
}

###################
# Post Lambda
###################
resource "aws_lambda_function" "post" {
   function_name = "post-${var.environment}"

   # The bucket name as created earlier with "aws s3api create-bucket"
   s3_bucket = var.s3_bucket
   s3_key    = "v1.0.0/post.zip"

   # "main" is the filename within the zip file (main.js) and "handler"
   # is the name of the property under which the handler function was
   # exported in that file.
   handler = "main.handler"
   runtime = "nodejs12.x"

   role = aws_iam_role.lambda_exec.arn

   environment {
    variables = {
      GAMES_TABLE = var.table_name
    }
  }
}

 # IAM role which dictates what other AWS services the Lambda function
 # may access.
resource "aws_iam_role" "lambda_exec" {
   name = "serverless_example_lambda"

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

resource "aws_iam_role_policy" "dynamodb-lambda-policy"{
  name = "dynamodb_lambda_policy"
  role = aws_iam_role.lambda_exec.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "dynamodb:BatchGet*",
          "dynamodb:DescribeStream",
          "dynamodb:DescribeTable",
          "dynamodb:Get*",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchWrite*",
          "dynamodb:CreateTable",
          "dynamodb:Delete*",
          "dynamodb:Update*",
          "dynamodb:PutItem"
      ],
      "Resource": "${var.table_arn}"
    }
  ]
}
EOF
}