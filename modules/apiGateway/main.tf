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

resource "aws_api_gateway_method" "get" {
   rest_api_id   = aws_api_gateway_rest_api.api.id
   resource_id   = aws_api_gateway_resource.resource.id
   http_method   = "GET"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "get" {
   rest_api_id = aws_api_gateway_rest_api.api.id
   resource_id = aws_api_gateway_resource.resource.id
   http_method = aws_api_gateway_method.get.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = var.get_invoke_arn
}

resource "aws_api_gateway_deployment" "deploy" {
   depends_on = [
     aws_api_gateway_integration.get,
     aws_api_gateway_method.get,
     aws_api_gateway_integration_response.get_response_integration
   ]

   rest_api_id = aws_api_gateway_rest_api.api.id
   stage_name  = "test"
}

# lambda => GET response
resource "aws_api_gateway_method_response" "get_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_integration.get.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "get_response_integration" {
  depends_on = [aws_api_gateway_integration.get]

  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method_response.get_response.http_method
  status_code = aws_api_gateway_method_response.get_response.status_code
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

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.get_function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*"
}
