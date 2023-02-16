resource "kubectl_manifest" "application" {
  for_each   = toset(var.applications)
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
        targetRevision: master
        path: dev/${each.value}/chart
        helm:
          valueFiles:
            - /ops/environments/${var.environment}/05_applications/${each.value}_values.yaml
      destination:
        server: https://kubernetes.default.svc
        namespace: ${var.applications_namespace}

      syncPolicy:
        syncOptions:
          - CreateNamespace=true
        automated:
          selfHeal: true
  YAML
}

resource "kubectl_manifest" "application_nginx_ingress_controller" {
  depends_on = [kubectl_manifest.argocd]

  yaml_body = <<-YAML
    apiVersion: argoproj.io/v1alpha1
    kind: Application
    metadata:
      name: ingress-nginx
      namespace: argocd
    spec:
      project: default

      source:
        repoURL: https://kubernetes.github.io/ingress-nginx
        chart: ingress-nginx
        targetRevision: 4.5.2
        helm:
          values: |
            controller:
              service:
                type: LoadBalancer
                annotations:
                  service.beta.kubernetes.io/aws-load-balancer-type: nlb
      destination:
        server: https://kubernetes.default.svc
        namespace: ingress-nginx

      syncPolicy:
        syncOptions:
          - CreateNamespace=true
        automated:
          selfHeal: true
  YAML
}
