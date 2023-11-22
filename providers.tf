terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 5.11.0"
      configuration_aliases = [aws.global]
    }
  }
}

provider "aws" {
  alias  = "global"
  region = "us-east-1"
}