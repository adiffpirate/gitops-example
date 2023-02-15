resource "kubectl_manifest" "namespace" {
  yaml_body = <<-YAML
    apiVersion: v1
    kind: Namespace
    metadata:
      name: ${var.namespace}
  YAML
}

data "kubectl_file_documents" "argocd" {
  content = file("${path.module}/manifest.yaml")
}

resource "kubectl_manifest" "argocd" {
  for_each   = data.kubectl_file_documents.argocd.manifests
  depends_on = [kubectl_manifest.namespace]

  yaml_body = each.value
  override_namespace = var.namespace
}
