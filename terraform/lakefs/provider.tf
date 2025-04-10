
terraform {
  backend "s3" {
    # Variables not allowed so hardcode
    key     = "lakefs-ec2/lakefs/terraform.tfstate"
    region  = "us-east-1"
    profile = "dgimeno"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.81.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}