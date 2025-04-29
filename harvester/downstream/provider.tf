terraform {
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
      version = "6.1.4"
    }
  }
}

provider "rancher2" {
  api_url    = var.rancher_fqdn
  access_key = var.rancher2_access_key
  secret_key = var.rancher2_secret_key
  insecure   = true
}
