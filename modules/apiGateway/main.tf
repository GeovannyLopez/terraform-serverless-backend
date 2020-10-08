provider "aws" {
  region = "us-east-1"
}

###################
# Api Gateway
###################
resource "aws_api_gateway_rest_api" "gateway" {
  name        = "my-api-${var.environment}"
  description = "Terraform Serverless Application"
}

 resource "aws_api_gateway_resource" "proxy" {
   rest_api_id = aws_api_gateway_rest_api.gateway.id
   parent_id   = aws_api_gateway_rest_api.gateway.root_resource_id
   path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
   rest_api_id   = aws_api_gateway_rest_api.gateway.id
   resource_id   = aws_api_gateway_resource.proxy.id
   http_method   = "ANY"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "get" {
   rest_api_id = aws_api_gateway_rest_api.example.id
   resource_id = aws_api_gateway_method.gateway.resource_id
   http_method = aws_api_gateway_method.gateway.http_method

   integration_http_method = "GET"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.example.invoke_arn
}

resource "aws_api_gateway_deployment" "deploy" {
   depends_on = [
     aws_api_gateway_integration.get
   ]

   rest_api_id = aws_api_gateway_rest_api.gateway.id
   stage_name  = "test"
}
