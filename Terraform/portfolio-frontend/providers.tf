terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "eu-south-2"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}