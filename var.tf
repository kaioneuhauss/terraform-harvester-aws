variable "aws_region" {
  type        = string
  default     = "us-east-1"
}

variable "aws_access_key" {
    type      = string
    default   = ""
}

variable "aws_secret_key" {
    type      = string
    default   = ""
}

variable "vpc_id" {
  description = "VPC ID onde as instâncias serao criadas"
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "Subnet pública para as instancias"
  type        = string
  default     = ""
}

variable "subnet_id2" {
  description = "Subnet pública para as instancias"
  type        = string
  default     = ""
}

variable "key_name" {
  description = "Nome da chave SSH"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "Tipo da instancia EC2"
  type        = string
  default     = "t2.medium"
}

variable "number_nodes" {
  description = "Numero de instancias EC2"
  type        = number
  default     = 3
}

variable "environment" {
  description = "Ambiente (dev/prod)"
  type        = string
  default     = "dev"
}

variable "ami_id" {
  description = "ami id do Sistema operacional utilizado"
  type        = string
  default     = "ami-04b7f73ef0b798a0f"
}

variable "public_subnet_id" {
  description = "id da subnet public1 criada"
  type        = string
  default     = ""
}

variable "private_subnet_id" {
  description = "id da subnet private1 criada"
  type        = string
  default     = ""
}

variable "route_table_id" {
  description = "id da route table associada"
  type        = string
  default     = ""
}

variable "kubernetes_version" {
  description = "versao kubernetes do cluster"
  type        = string
  default     = "v1.30.8+rke2r"
}

variable "cluster_token" {
  description = "versao kubernetes do cluster"
  type        = string
  default     = "rancher"
}

variable "vm_user" {
  description = "versao kubernetes do cluster"
  type        = string
  default     = "ubuntu"
}

#----------------------------------configuracoes para o rancher manager------------------------#
#tenho que referenciar a chave privada local para que possa executar o remote-exec
variable "private_key_filename" {
  description = "Nome do arquivo da chave privada PEM localizado na raiz do projeto"
  type        = string
  default     = ""
}

variable "kubeconfig_filename" {
  description = "Kubeconfig do cluster RKE2 do Rancher"
  type        = string
  default     = "./kubeconfig.yaml"
}

variable "rancher_version" {
  type        = string
  default     = "2.10.4"
}

variable "rancher_bootstrap_password" {
  type        = string
  default     = "admin"
}

variable "rancher_server_dns" {
  type        = string
  description = "Hostname que será usado pelo Rancher"
  default     = "rancher-aws.neuhauss.com.br"
}
