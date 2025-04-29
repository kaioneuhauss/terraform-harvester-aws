# Helm resources
resource "local_file" "kube_config_server_yaml" {
  filename = var.kubeconfig_filename
  content  = ssh_resource.retrieve_config.result
}

# Install cert-manager helm chart
resource "helm_release" "cert_manager" {
  depends_on = [
    harvester_virtualmachine.rancher,
    harvester_virtualmachine.rancher-2,
    harvester_virtualmachine.rancher-3,
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

# Install Rancher helm chart
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
    value = 3
  }
  set {
    name = "antiAffinity"
    value = "required"
  }
}
