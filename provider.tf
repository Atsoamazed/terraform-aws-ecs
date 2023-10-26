terraform {
  required_version = ">= 1.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn     = module.lookups.scalr_role_arns[var.account_name]
    session_name = "Scalr_${var.account_name}"
    external_id  = module.lookups.scalr_role_external_ids[var.account_name]
  }
}
