output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "base_url" {
  description = "Base url of api gateway"
  value       = module.apiGateway.base_url
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "get_invoke_arn" {
  value = module.lambda.get_invoke_arn
}