provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
  }
}

locals {
  cluster_autoscaler_values_default = <<-YAML
    replicaCount: 2

    cloudProvider: aws
    awsRegion: ${var.region}

    rbac:
      create: true
      serviceAccount:
        name: cluster-autoscaler-aws
        create: true
        annotations:
          eks.amazonaws.com/role-arn: ${module.cluster_autoscaler_irsa_role.iam_role_arn}

    autoDiscovery:
      enabled: true
      clusterName: ${module.eks.cluster_name}

    extraArgs:
      ignore-daemonsets-utilization: true
      skip-nodes-with-local-storage: false
  YAML
}

resource "helm_release" "cluster_autoscaler" {
  depends_on = [module.eks]

  name            = "cluster-autoscaler"
  chart           = "cluster-autoscaler"
  version         = "9.24.0"
  repository      = "https://kubernetes.github.io/autoscaler"
  namespace       = "kube-system"

  values = [
    local.cluster_autoscaler_values_default,
    var.cluster_autoscaler_custom_values
  ]
}

module "cluster_autoscaler_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.11.2"

  role_name = "${var.project}-${var.environment}-eks-cluster-autoscaler"

  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_ids   = [module.eks.cluster_name]

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:cluster-autoscaler-aws"]
    }
  }

  tags = merge(
    { Name = "${var.project}-${var.environment}-eks-cluster-autoscaler" },
    local.tags,
  )
}
