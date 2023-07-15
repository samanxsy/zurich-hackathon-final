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

module "EC2" {
    source = "./EC2"
    zurich_subnet_id = module.VPC.zurich_subnet_id
    zurich_security_group = module.VPC.zurich_security_group
}

module "VPC" {
    source = "./VPC" 
}
