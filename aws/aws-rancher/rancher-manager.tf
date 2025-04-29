#Salva localmente o kubeconfig ajustado
resource "local_file" "kube_config_server_yaml" {
  filename = "${path.module}/${var.kubeconfig_filename}"
  content  = ssh_resource.retrieve_config.result
  depends_on = [ssh_resource.retrieve_config]
}

# Valida o kubeconfig (precisa do kubectl local)
resource "null_resource" "validate_kubeconfig" {
  depends_on = [local_file.kube_config_server_yaml]

  provisioner "local-exec" {
    command = "KUBECONFIG=${path.module}/${var.kubeconfig_filename} kubectl get nodes"
  }
}

# instalacao do cert-manager
resource "helm_release" "cert_manager" {
depends_on = [
  null_resource.wait_cloudinit_node1,
  null_resource.wait_cloudinit_node_rest,
  local_file.kube_config_server_yaml
]

  name             = "cert-manager"
  chart            = "jetstack/cert-manager"
  namespace        = "cert-manager"
  create_namespace = true
  wait             = true

  set {
    name  = "installCRDs"
    value = "true"
  }
}

# instalacao do rancher
resource "helm_release" "rancher_server" {
  depends_on = [
    helm_release.cert_manager
  ]

  name             = "rancher"
  chart            = "rancher-prime/rancher"
  namespace        = "cattle-system"
  create_namespace = true
  wait             = true
  version          = var.rancher_version

  set {
    name  = "hostname"
    value = var.rancher_server_dns
  }

  set {
    name  = "bootstrapPassword"
    value = var.rancher_bootstrap_password
  }

  set {
    name  = "replicas"
    value = "3"
  }

  set {
    name  = "antiAffinity"
    value = "required"
  }
}