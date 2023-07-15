#############################################
############ T E R R A F O R M ##############

# State
terraform {
  backend "s3" {
    bucket         = "statebucketx"
    key            = "finalphaste/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-state-lock" # TO REJECT SIMULTANEOUS INFRASTRUCTURE PROVISIONING BY A TEAM
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

module "s3-frontend-server" {
  source                 = "./S3Front"
  domain_name            = "zurich.com"
  api_gateway_stage_name = module.backend.api_gateway_stage_name
  lambda_function_name   = module.backend.lambda_function_name
}

module "storage" {
  source = "./Storage"
}

module "backend" {
  source = "./Backend"
}
