provider "aws" {
  region = "us-east-1"
}

###################
# Api Gateway
###################
resource "aws_api_gateway_rest_api" "api" {
  name        = "my-api-${var.environment}"
  description = "Terraform Serverless Application"
}

 resource "aws_api_gateway_resource" "resource" {
   rest_api_id = aws_api_gateway_rest_api.api.id
   parent_id   = aws_api_gateway_rest_api.api.root_resource_id
   path_part   = "games"
}

###################
# Methods
###################

resource "aws_api_gateway_method" "get" {
   rest_api_id   = aws_api_gateway_rest_api.api.id
   resource_id   = aws_api_gateway_resource.resource.id
   http_method   = "GET"
   authorization = "NONE"
}

resource "aws_api_gateway_method" "post" {
   rest_api_id   = aws_api_gateway_rest_api.api.id
   resource_id   = aws_api_gateway_resource.resource.id
   http_method   = "POST"
   authorization = "NONE"
}

###################
# GET
###################

resource "aws_api_gateway_integration" "get" {
   rest_api_id = aws_api_gateway_rest_api.api.id
   resource_id = aws_api_gateway_resource.resource.id
   http_method = aws_api_gateway_method.get.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = var.get_invoke_arn
}

resource "aws_lambda_permission" "api-gateway-invoke-get-lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.get_function_arn
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the specified API Gateway.
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

###################
# POST
###################

resource "aws_api_gateway_integration" "post" {
   rest_api_id = aws_api_gateway_rest_api.api.id
   resource_id = aws_api_gateway_resource.resource.id
   http_method = aws_api_gateway_method.post.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = var.post_invoke_arn
}

resource "aws_lambda_permission" "api-gateway-invoke-post-lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.post_function_arn
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the specified API Gateway.
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

###################
# DEPLOY
###################

resource "aws_api_gateway_deployment" "deploy" {
   depends_on = [
     aws_api_gateway_integration.get,
     aws_api_gateway_method.get,
     aws_api_gateway_integration.post,
     aws_api_gateway_method.post
   ]

   rest_api_id = aws_api_gateway_rest_api.api.id
   stage_name  = "test"
}