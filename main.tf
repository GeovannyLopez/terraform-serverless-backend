provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"
  environment = var.environment
  owner = var.owner
}