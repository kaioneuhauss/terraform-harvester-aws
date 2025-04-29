variable "rancher2_access_key" {
  type= string
  default= ""
}

variable "rancher2_secret_key" {
  type= string
  default= ""
}

variable "gateway" {
  type= string
  default= "192.168.20.1"
}

variable "nameserver" {
  type= string
  default= "192.168.1.101"
}

variable "cloud_credential_secret" {
  type = string
  default = ""
}


variable "vm_namespace" {
  type = string
  default = "prod"
}


variable "number_masters" {
  type = number
  default = "3"
}

variable "number_workers" {
  type = number
  default = "4"
}

variable "dns_local" {
  type = string
  default = "192.168.20.150"
}

variable "kubernetes_version" {
  type = string
  default = "v1.31.7+rke2r1"
}

variable "cluster_name" {
  type = string
  default = "prod"
}

variable "cluster_cni" {
  type = string
  default = "calico"
}

variable "vlan_vm_name" {
  type = string
  default = "vlan-vm"
}

variable "vlan_vm_namespace" {
  type = string
  default = "vlan"
}

variable "iso_vm_name" {
  type = string
  default = "image-v8ddp"
}


variable "iso_vm_namespace" {
  type = string
  default = "isos"
}

variable "kubeconfig_file" {
  type = string
  default = "prod-kubeconfig"
}

variable "rancher_fqdn" {
  type = string
  default = ""
}

