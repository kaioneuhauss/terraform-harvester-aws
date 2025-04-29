terraform {
  required_version = ">= 0.13"
  required_providers {
    harvester = {
      source  = "harvester/harvester"
      version = "0.6.6"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
    }
    ssh = {
      source  = "loafoe/ssh"
      version = "2.7.0"
    }
  }
  backend "kubernetes" {
    secret_suffix    = "state-rke2"
    config_path      = "/root/.kube/harvester.yaml" 
  }
}

provider "harvester" {
}
provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_filename
  }
}

