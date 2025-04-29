terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.95.0"
    }
    
        local = {
      source  = "hashicorp/local"
      version = "2.5.2"
    }
    
    ssh = {
      source  = "loafoe/ssh"
      version = "~> 2.7.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "helm" {
  kubernetes {
    config_path    = var.kubeconfig_filename
  }
}