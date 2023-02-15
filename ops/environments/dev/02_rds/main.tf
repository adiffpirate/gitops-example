terraform {
  backend "s3" {
    region         = "us-west-1"
    bucket         = "gitops-example-dev-terraform-state"
    key            = "02_rds/terraform.state"
    dynamodb_table = "gitops-example-dev-terraform-state-lock"
  }
}

provider "aws" {
  region  = "us-west-1"
  profile = "gitops-example-dev"
}

module "rds" {
  source  = "../../../tf_modules/rds"

  project     = "gitops-example"
  environment = "dev"
  azs         = ["us-west-1a", "us-west-1b"]

  one_instance_per_az = true

  engine         = "aurora-postgresql"
  engine_version = "14.5"
  instance_type  = "db.t4g.medium"

  public_access = true # ATTENTION: For testing/demonstrations purposes only. SHOULD NOT BE USED IN PRODUCTION

  create_databases = [
    "api"
  ]

  backup_retention_period = 1
  skip_final_snapshot     = true

  vpc_tags = {
    "environment" = "dev"
    "project"     = "gitops-example"
  }

  subnets_tags = {
    "environment" = "dev"
    "project"     = "gitops-example"
    "scope"       = "database"
  }
}
