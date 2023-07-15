variable "lambda_function_name" {
  type = string
}

variable "api_gateway_stage_name" {
  type = string
}

variable "domain_name" {
  type    = string
  default = "zurich.com"
}
