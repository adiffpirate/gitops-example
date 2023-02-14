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

  cidr = "10.0.0.0/16"
  azs  = ["us-west-1a", "us-west-1b"]

  private_subnets_cidr   = ["10.0.0.0/18", "10.0.64.0/18"]
  public_subnets_cidr    = ["10.0.128.0/18", "10.0.192.0/18"]
  one_nat_gateway_per_az = false
}
