############ LAMBDA & API GATEWAY #############
###############################################

# LAMBDA FUNCTION
resource "aws_lambda_function" "zurich_lambda_function" {
  function_name = "zurich-lambda-function"
  role          = aws_iam_role.zurich_lambda_role.arn
  handler       = "main.lambda_handler"
  runtime       = "python3.10"
  timeout       = 15
  memory_size   = 128

  # Lambda Code Path
  filename = "Backend/lambda_function.zip" # FOR THE FUNCTION CODE. Unfortunately could not find the time code the functions

  tracing_config {
    mode = "Active"
  }

  # Environment variables
  environment {
    variables = {
      VAR_ONE     = "# var.aws_resource"
      VAR_TWO_ARN = "# var.aws_resource_arn"
    }
  }
}


# IAM ROLE
resource "aws_iam_role" "zurich_lambda_role" {
  name = "lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# S3 ACCESS
resource "aws_iam_policy_attachment" "lambda_S3_role" {
  name       = "lambda-s3-access"
  roles      = [aws_iam_role.zurich_lambda_role.id]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# DYNAMODB ACCESS
resource "aws_iam_policy_attachment" "lambda_DynamoDB_role" {
  name       = "lambda-dynamodb-access"
  roles      = [aws_iam_role.zurich_lambda_role.id]
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

# Allow lambda to be invoked by API GATE WAY
resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.zurich_lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = aws_api_gateway_rest_api.webapp_gateway.arn
}


################################################
################ API GATE WAY ##################

# RESTFUL API
resource "aws_api_gateway_rest_api" "webapp_gateway" {
  name        = "WebApp-API-GateWay"
  description = "Web app API GateWay to Lambda functions"
}

# API GATE WAY RESOURCE
resource "aws_api_gateway_resource" "gateway_resource" {
  rest_api_id = aws_api_gateway_rest_api.webapp_gateway.id
  parent_id   = aws_api_gateway_rest_api.webapp_gateway.root_resource_id
  path_part   = "photos"
} # MORE & NESTED RESOURCE COULD BE ADDED

# METHODS
resource "aws_api_gateway_method" "webapp_method" {
  rest_api_id   = aws_api_gateway_rest_api.webapp_gateway.id
  resource_id   = aws_api_gateway_resource.gateway_resource.id
  http_method   = "GET"
  authorization = "AWS_IAM"
}

# Integrating API GateWay with Lambda
resource "aws_api_gateway_integration" "gateway_integration" {
  rest_api_id             = aws_api_gateway_rest_api.webapp_gateway.id
  resource_id             = aws_api_gateway_resource.gateway_resource.id
  http_method             = aws_api_gateway_method.webapp_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.zurich_lambda_function.invoke_arn
}

# Deployment
resource "aws_api_gateway_deployment" "webapp_deployment" {
  rest_api_id = aws_api_gateway_rest_api.webapp_gateway.id
  stage_name  = "zurich-webapp-stage"
}

# Stage
resource "aws_api_gateway_stage" "gateway_stage" {
  rest_api_id   = aws_api_gateway_rest_api.webapp_gateway.id
  stage_name    = "zurich-webapp-stage"
  deployment_id = aws_api_gateway_deployment.webapp_deployment.execution_arn
}
