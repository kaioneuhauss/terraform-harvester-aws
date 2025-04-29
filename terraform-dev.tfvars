#Resources that needs to be created before running terraform
aws_region           = "us-east-1"
aws_access_key       = ""
aws_secret_key       = ""
vpc_id               = ""
subnet_id            = "" #subnet public east1b
public_subnet_id     = "" #subnet public east1a
private_subnet_id    = ""
route_table_id       = "" #route table of your private subnet that will be used
key_name             = "" #private key created on aws
private_key_filename = "" #the private key needs to be in the project directory

#These resources will be created while running terraform
instance_type              = "c5.xlarge"
number_nodes               = "3"
environment                = "dev"
vm_user                    = "ec2-user"
ami_id                     = "ami-04b7f73ef0b798a0f" #ami-04b7f73ef0b798a0f imagem sles
kubernetes_version         = "v1.31.7+rke2r1"
cluster_token              = "rancher"
kubeconfig_filename        = "kubeconfig.yaml"
rancher_server_dns         = "" #you will need a public domain and point on your DNS
rancher_bootstrap_password = "admin"
rancher_version            = "2.10.4"
