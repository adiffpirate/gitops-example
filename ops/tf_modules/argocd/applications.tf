resource "kubectl_manifest" "application" {
  for_each   = toset(var.microservices)
  depends_on = [kubectl_manifest.argocd]

  yaml_body = <<-YAML
    apiVersion: argoproj.io/v1alpha1
    kind: Application
    metadata:
      name: ${each.value}
      namespace: argocd
    spec:
      project: default

      source:
        repoURL: https://github.com/adiffpirate/gitops-example
        targetRevision: feature/argocd
        path: dev/${each.value}/chart
        helm:
          valueFiles:
            - /ops/environments/${var.environment}/05_application/${each.value}_values.yaml
      destination:
        server: https://kubernetes.default.svc
        namespace: ${var.microservices_namespace}

      syncPolicy:
        syncOptions:
          - CreateNamespace=true
        automated:
          selfHeal: true
          prune: true
  YAML
}
