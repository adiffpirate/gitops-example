resource "kubectl_manifest" "application_api" {
  depends_on = [kubectl_manifest.argocd]

  yaml_body = <<-YAML
    apiVersion: argoproj.io/v1alpha1
    kind: Application
    metadata:
      name: api
      namespace: argocd
    spec:
      project: default

      source:
        repoURL: https://github.com/adiffpirate/gitops-example
        targetRevision: feature/argocd
        path: dev/api/chart
        helm:
          valueFiles:
            - /ops/environments/${var.environment}/05_application/api_values.yaml
      destination:
        server: https://kubernetes.default.svc
        namespace: app

      syncPolicy:
        syncOptions:
          - CreateNamespace=true
        automated:
          selfHeal: true
          prune: true
  YAML
}
