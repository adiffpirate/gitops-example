#------#
# APPS #
#------#

resource "kubectl_manifest" "application" {
  for_each   = toset(var.applications)
  depends_on = [helm_release.argocd]

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
          - ServerSideApply=true
        automated:
          prune: true
          selfHeal: true
  YAML
}

#--------------------------#
# NGINX Ingress Controller #
#--------------------------#

resource "kubectl_manifest" "application_nginx_ingress_controller" {
  depends_on = [helm_release.argocd]

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
          - ServerSideApply=true
        automated:
          prune: true
          selfHeal: true
  YAML
}

#-------------------------#
# Prometheus with Grafana #
#-------------------------#

resource "kubectl_manifest" "application_prometheus" {
  depends_on = [helm_release.argocd]

  yaml_body = <<-YAML
    apiVersion: argoproj.io/v1alpha1
    kind: Application
    metadata:
      name: prometheus
      namespace: argocd
    spec:
      project: default

      source:
        repoURL: https://prometheus-community.github.io/helm-charts
        chart: kube-prometheus-stack
        targetRevision: 56.6.2
      destination:
        server: https://kubernetes.default.svc
        namespace: observability

      syncPolicy:
        syncOptions:
          - CreateNamespace=true
          - ApplyOutOfSyncOnly=true
          - ServerSideApply=true
        automated:
          prune: true
          selfHeal: true
  YAML
}
