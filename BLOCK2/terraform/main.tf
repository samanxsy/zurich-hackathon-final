#############################################
############ T E R R A F O R M ##############


# State
terraform {
  backend "s3" {
    bucket = "statebucketx"
    key = "finalphaste/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "tf-state-lock"
    encrypt = true
  }

  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

provider "aws" {
    region = "eu-central-1"
}

module "s3-static-website" {
  source  = "cn-terraform/s3-static-website/aws"
  version = "1.0.8"
  name_prefix = "WebApp-FrontEnd-Handler"
  website_domain_name = "webapp.zurich.com"
}

module "storage" {
  source = "./Storage"
}

module "backend" {
  source = "./Backend"
}
