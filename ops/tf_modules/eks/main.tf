provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

data "aws_vpc" "vpc" {
  tags = var.tags_get_vpc
}

data "aws_subnets" "subnets" {
  tags = var.tags_get_subnets
}

data "aws_subnet" "subnet" {
  for_each = toset(data.aws_subnets.subnets.ids)

  id = each.key
}

locals {
  vpc_cidr     = data.aws_vpc.vpc.cidr_block
  subnets_cidr = values(data.aws_subnet.subnet)[*].cidr_block

  tags = {
    project     = var.project,
    environment = var.environment
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.7.0"

  cluster_name    = "${var.project}-${var.environment}"
  cluster_version = var.cluster_version

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = var.public_access

  vpc_id     = data.aws_vpc.vpc.id
  subnet_ids = data.aws_subnets.subnets.ids

  eks_managed_node_groups = var.managed_node_groups

  enable_irsa = true

  cluster_addons = {
    coredns = {
      most_recent       = true
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {
      most_recent       = true
      resolve_conflicts = "OVERWRITE"
    }
    vpc-cni = {
      most_recent              = true
      resolve_conflicts        = "OVERWRITE"
      service_account_role_arn = module.vpc_cni_irsa.iam_role_arn
    }
  }

  cluster_security_group_additional_rules  = {
    admin_access = {
      description  = "Allows access to Kubernetes API"
      type         = "ingress"
      cidr_blocks  = var.public_access ? ["0.0.0.0/0"] : [local.vpc_cidr]
      protocol     = "tcp"
      from_port    = 443
      to_port      = 443
	  }
  }

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      type        = "ingress"
      cidr_blocks = local.subnets_cidr
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
	  },
    egress_all = {
      description      = "Allow egress access to everywhere"
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
	  }
  }

  cluster_enabled_log_types              = ["audit", "api", "authenticator", "controllerManager", "scheduler"]
  cloudwatch_log_group_retention_in_days = var.log_retention_period

  manage_aws_auth_configmap = true
  aws_auth_roles    = var.aws_auth_extra_roles
  aws_auth_users    = var.aws_auth_extra_users
  aws_auth_accounts = var.aws_auth_extra_accounts

  tags = merge(
    { Name = "${var.project}-${var.environment}" },
    local.tags,
  )
}

module "vpc_cni_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.11.2"

  role_name = "${var.project}-${var.environment}-eks-vpc-cni"

  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }

  tags = merge(
    { Name = "${var.project}-${var.environment}-eks-vpc-cni" },
    local.tags,
  )
}
