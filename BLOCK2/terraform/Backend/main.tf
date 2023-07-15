############ LAMBDA & API GATEWAY #############
###############################################

# LAMBDA FUNCTION
resource "aws_lambda_function" "zurich_lambda_function" {
    function_name = "zurich-lambda-function"
    role = aws_iam_role.zurich_lambda_role.arn
    handler = "main.lambda_handler"
    runtime = "python3.10"
    timeout = 15
    memory_size = 128

    # Lambda Code Path
    filename = "Backend/lambda_function.zip"

    tracing_config {
      mode = "Active"
    }

    # Environment variables
    environment {
      variables = {
        VAR_ONE = "# var.aws_resource"
        VAR_TWO_ARN = "# var.aws_resource_arn"
      }
    }
}


# IAM ROLE
resource "aws_iam_role" "iam_lambda_role" {
    name = "CHANGE-MY-NAME"

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
    name = "lambda-s3-access"
    roles = [aws_iam_role.lambda_role.id] # OR OTHER SERVICE ROLES ------ Change the lambda_S3_role respectively. e.g to EC2_S3_role in case.
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# DYNAMODB ACCESS
resource "aws_iam_policy_attachment" "lambda_DynamoDB_role" {
    name = "lambda-dynamodb-access"
    roles = [aws_iam_role.lambda_role.id]
    policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}


# API GATE WAY
resource "aws_api_gateway_rest_api" "webapp_gateway" {
  name = "WebApp-API-GateWay"
  description = "Web app API GateWay to Lambda functions"
}

resource "aws_api_gateway_resource" "gateway_resource" {
  rest_api_id = aws_api_gateway_rest_api.webapp_gateway.id
  parent_id = aws_api_gateway_rest_api.webapp_gateway.root_resource_id
  path_part = "examplepath"
}

resource "aws_api_gateway_method" "webapp_method" {
  rest_api_id = aws_api_gateway_rest_api.webapp_gateway.id
  resource_id = aws_api_gateway_resource.gateway_resource.id
  http_method = "GET"
  authorization = "AWS_IAM" # CHANGE IT LATER
}

resource "aws_api_gateway_integration" "gateway_integration" {
  rest_api_id = aws_api_gateway_rest_api.webapp_gateway.id
  resource_id = aws_api_gateway_resource.gateway_resource.id
  http_method = aws_api_gateway_method.webapp_method.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.zurich_lambda_function.invoke_arn
}
