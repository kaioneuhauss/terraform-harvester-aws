variable "rancher_api_url" {
  type    = string
  default = "" #fqdn of your rancher server with https
}

variable "rancher_token" {
  type    = string
  default = ""
}

variable "cloud_credential" {
  type    = string
  default = "aws-cloud-credential"
}

variable "cluster_name" {
  type    = string
  default = "aws-cluster"
}

variable "aws_access_key" {
  type    = string
  default = ""
}

variable "aws_secret_key" {
  type    = string
  default = ""
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_ami" {
  type    = string
  default = "ami-04b7f73ef0b798a0f"
}

variable "aws_instance_type_master" {
  type    = string
  default = "c5.xlarge"
}

variable "aws_instance_type_worker" {
  type    = string
  default = "c5.xlarge"
}

variable "ssh_user" {
  type    = string
  default = "ubuntu" # ou 'ec2-user' para AMIs SUSE
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "subnet_id" {
  type    = string
  default = ""
}

variable "security_group" {
  type    = string
  default = "rancher-nodes" #security group rancher-nodes criado anteriormente
}

variable "zone" {
  type    = string
  default = "a" #espera apenas o valor da zona (pode ser a,b,c,d)
}

variable "iam_profile" {
  type    = string
  default = "rancher-downstream"
}

variable "kubernetes_version" {
  type    = string
  default = "v1.31.7+rke2r1"
}

variable "root_disk_master" {
  type    = string
  default = "30"
}

variable "root_disk_worker" {
  type    = string
  default = "50"
}

variable "private_address" {
  type    = string
  default = "false"
}

variable "number_master" {
  type    = number
  default = "3"
}

variable "number_worker" {
  type    = number
  default = "2"
}
