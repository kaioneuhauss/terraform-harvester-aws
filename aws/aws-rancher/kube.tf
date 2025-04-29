resource "null_resource" "copy_private_key_to_bastion" {
  depends_on = [null_resource.wait_cloudinit_node1,
                null_resource.wait_cloudinit_node_rest,
  ]

  provisioner "file" {
    source      = "${path.module}/${var.private_key_filename}"
    destination = "/home/ec2-user/${var.private_key_filename}"

    connection {
      type        = "ssh"
      host        = aws_instance.bastion.public_ip
      user        = "ec2-user"
      private_key = file("${path.module}/${var.private_key_filename}")
    }
  }
}

resource "ssh_resource" "retrieve_config" {
  host        = aws_instance.bastion.public_ip
  user        = "ec2-user"
  private_key = file("${path.module}/${var.private_key_filename}")

  depends_on = [
    aws_instance.bastion,
    aws_instance.rke2_node_1,
    null_resource.copy_private_key_to_bastion
  ]

  commands = [
    # Corrige permissão da chave no bastion
    "chmod 600 /home/ec2-user/${var.private_key_filename}",

    # Executa o sed no node 1 via bastion e retorna só o kubeconfig
    <<-EOT
      ssh -o StrictHostKeyChecking=no -i /home/ec2-user/${var.private_key_filename} ec2-user@${aws_instance.rke2_node_1.private_ip} \
        "sudo sed 's|127.0.0.1|${aws_lb.rancher_nlb.dns_name}|g' /etc/rancher/rke2/rke2.yaml"
    EOT
  ]
}