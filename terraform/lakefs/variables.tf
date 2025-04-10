
locals {
  resource_name_prefix  = "lakefs-ec2"
  resource_name_suffix  = terraform.workspace
  resource_name_default = "${local.resource_name_prefix}-${local.resource_name_suffix}"
}

variable "aws_profile" {
  type        = string
  description = "AWS Profile"
  default     = "dgimeno"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "vpc_id" {
  type        = string
  description = "VPC Id"
}

variable "subnet_id" {
  type        = string
  description = "VPC Subnet Id"
}

variable "key_name" {
  type = string
}
