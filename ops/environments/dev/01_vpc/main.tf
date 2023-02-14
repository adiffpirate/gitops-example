terraform {
  backend "s3" {
    region         = "us-west-1"
    bucket         = "gitops-example-dev-terraform-state"
    key            = "01_vpc/terraform.state"
    dynamodb_table = "gitops-example-dev-terraform-state-lock"
  }
}

provider "aws" {
  region  = "us-west-1"
  profile = "gitops-example-dev"
}

module "vpc" {
  source  = "../../../tf_modules/vpc"

  project     = "gitops-example"
  environment = "dev"

  name = "gitops-example-vpc"
  cidr = "10.0.0.0/16"
  azs  = ["us-west-1a", "us-west-1b"]

  private_subnets_cidr   = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
  public_subnets_cidr    = ["10.0.112.0/20", "10.0.128.0/20", "10.0.144.0/20"]
  one_nat_gateway_per_az = false
}
