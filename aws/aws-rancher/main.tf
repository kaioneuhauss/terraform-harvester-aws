resource "aws_instance" "rke2_node_1" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_id
  associate_public_ip_address = false
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.rke2_sg.id]

  root_block_device {
    volume_size           = 60
    volume_type           = "gp3"
    delete_on_termination = true
  }
  
  user_data = templatefile("${path.module}/templates/cloud-init-rancher1.yaml", {
    cluster_token      = var.cluster_token,
    lb_hostname        = aws_lb.rancher_nlb.dns_name,
    kubernetes_version = var.kubernetes_version
  })

  tags = {
    Name = "rancher-node-1"
  }
  depends_on = [
    aws_lb.rancher_nlb,
    aws_security_group.rke2_sg,
    aws_instance.bastion
  ]
}

resource "null_resource" "wait_cloudinit_node1" {
  provisioner "remote-exec" {
    inline = [
      "echo '⏳ Aguardando cloud-init no node 1...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Cloud-init finalizado no node 1!'"
    ]

    connection {
      type                = "ssh"
      host                = aws_instance.rke2_node_1.private_ip
      user                = "ec2-user"
      private_key         = file("${path.module}/${var.private_key_filename}")
      bastion_host        = aws_instance.bastion.public_ip
      bastion_user        = "ec2-user"
      bastion_private_key = file("${path.module}/${var.private_key_filename}")
    }
  }

  depends_on = [aws_instance.rke2_node_1]
}

resource "aws_instance" "rke2_node_rest" {
  count                       = var.number_nodes - 1
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_id
  associate_public_ip_address = false
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.rke2_sg.id]

  root_block_device {
    volume_size           = 60
    volume_type           = "gp3"
    delete_on_termination = true
  }

  user_data = templatefile("${path.module}/templates/cloud-init-rancher2-3.yaml", {
    cluster_token      = var.cluster_token,
    lb_hostname        = aws_lb.rancher_nlb.dns_name,
    kubernetes_version = var.kubernetes_version
  })

  tags = {
    Name = "rancher-node-${count.index + 2}"
  }

  depends_on = [null_resource.wait_cloudinit_node1]
}
resource "null_resource" "wait_cloudinit_node_rest" {
  count = var.number_nodes - 1

  provisioner "remote-exec" {
    inline = [
      "echo '⏳ Aguardando cloud-init no node ${count.index + 2}...'",
      "cloud-init status --wait > /dev/null",
      "echo '✅ Cloud-init finalizado no node ${count.index + 2}!'"
    ]

    connection {
      type                = "ssh"
      host                = aws_instance.rke2_node_rest[count.index].private_ip
      user                = "ec2-user"
      private_key         = file("${path.module}/${var.private_key_filename}")
      bastion_host        = aws_instance.bastion.public_ip
      bastion_user        = "ec2-user"
      bastion_private_key = file("${path.module}/${var.private_key_filename}")
    }
  }

  depends_on = [
    aws_instance.rke2_node_rest
  ]
}

resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = "t3.micro"
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "${var.environment}-bastion"
  }
  depends_on = [aws_security_group.bastion_sg]
}