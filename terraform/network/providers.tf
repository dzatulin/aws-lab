terraform {
  required_version = ">= 1.13.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region  = "eu-central-1"
  profile = "awslab"

  allowed_account_ids = ["768814603451"]

  default_tags {
    tags = {
      Project   = "aws-lab"
      ManagedBy = "Terraform"
      Env       = "lab"
    }
  }
}
