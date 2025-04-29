resource "rancher2_machine_config_v2" "aws_master" {
  generate_name = "aws-master-"

  amazonec2_config {
    region               = var.aws_region
    ami                  = var.aws_ami
    instance_type        = var.aws_instance_type_master
    ssh_user             = var.ssh_user
    vpc_id               = var.vpc_id
    subnet_id            = var.subnet_id
    security_group       = [var.security_group]
    zone                 = var.zone
    iam_instance_profile = var.iam_profile
    userdata             = file("cloud-init.yaml")
    root_size            = var.root_disk_master
  }
}

resource "rancher2_machine_config_v2" "aws_worker" {
  generate_name = "aws-worker-"

  amazonec2_config {
    region               = var.aws_region
    ami                  = var.aws_ami
    instance_type        = var.aws_instance_type_worker
    ssh_user             = var.ssh_user
    vpc_id               = var.vpc_id
    subnet_id            = var.subnet_id
    security_group       = [var.security_group]
    zone                 = var.zone
    iam_instance_profile = var.iam_profile
    userdata             = file("cloud-init.yaml")
    root_size            = var.root_disk_worker
  }
  depends_on = [rancher2_cloud_credential.aws_cred]
}
