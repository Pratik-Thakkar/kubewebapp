terraform {
  backend "s3" {                                                          # Built-in support for remote backends
    bucket         = "kubewebapp-state"                                   # S3 bucket name to store the state file
    key            = "terraform.tfstate"
    region         = "us-east-1"
                                                                          # Implement locking mechanism using dynamoDB
    dynamodb_table = "kubewebapp-locks"                                   # DynamoDB table name to acquire a lock
    encrypt        = true
  }
}

provider "aws" {
	region = "us-east-1"
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "webapp-dev-eks"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name                 = "eks-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}