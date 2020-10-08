output "table_name" {
  description = "The name of the table created"
  value       = aws_dynamodb_table.games.id
}

output "table_arn" {
  description = "The arn of the table created"
  value       = aws_dynamodb_table.games.arn
}