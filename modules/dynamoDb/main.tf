provider "aws" {
  region = "us-east-1"
}

###################
# DynamoDB
###################
resource "aws_dynamodb_table" "games" {
  name           = "games-${var.environment}"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "gameId"

  attribute {
    name = "gameId"
    type = "S"
  }

  tags = {
    Name        = "games-${var.environment}"
    Environment = "${var.environment}"
  }
}
