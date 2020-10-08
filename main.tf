provider "aws" {
  region = "us-east-1"
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
  invoke_arn = "${module.lambda.invoke_arn}"
  get_function_name = "${module.lambda.get_function_name}"
}

module "lambda" {
  source = "./modules/lambda"
  environment = var.environment
  owner = var.owner
}