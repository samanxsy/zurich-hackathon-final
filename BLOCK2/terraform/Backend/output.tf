output "api_gateway_stage_name" {
  value = aws_api_gateway_stage.gateway_stage.stage_name
}

output "lambda_function_name" {
  value = aws_lambda_function.zurich_lambda_function.function_name
}
