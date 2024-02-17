locals {
  argocd_values = <<-YAML
    server:
      resources:
        limits:
          memory: 64Mi
        requests:
          cpu: 50m
          memory: 64Mi

    controller:
      resources:
        limits:
          memory: 256Mi
        requests:
          cpu: 250m
          memory: 256Mi

    repoServer:
      resources:
        limits:
          memory: 64Mi
        requests:
          cpu: 10m
          memory: 64Mi

    redis:
      resources:
        limits:
          memory: 64Mi
        requests:
          cpu: 100m
          memory: 64Mi

    applicationSet:
      enabled: false

    notifications:
      enabled: false

    dex:
      enabled: false
  YAML
}

resource "helm_release" "argocd" {
  name = "argocd"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "6.1.0"

  namespace        = var.namespace
  create_namespace = true

  values = [
    local.argocd_values
  ]
}
