provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
  environment = var.environment
  owner = var.owner
}

module "dynamo" {
  source = "./modules/dynamoDb"
  environment = var.environment
  owner = var.owner
}

module "apiGateway" {
  source = "./modules/apiGateway"
  environment = var.environment
  owner = var.owner
  get_invoke_arn = module.lambda.get_invoke_arn
  get_function_arn = module.lambda.get_function_arn
  get_function_name = module.lambda.get_function_name
}

module "lambda" {
  source = "./modules/lambda"
  environment = var.environment
  owner = var.owner
  table_arn = "${module.dynamo.table_arn}"
  table_name = "${module.dynamo.table_name}"
  s3_bucket = var.s3_bucket
}

data "aws_caller_identity" "current" {}