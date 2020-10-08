output "get_arn" {
  description = "The arn of the get function created"
  value       = aws_lambda_function.get.arn
}

output "get_invoke_arn" {
  description = "The invoike arn of the get function created"
  value       = aws_lambda_function.get.invoke_arn
}