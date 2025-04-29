resource "ssh_resource" "retrieve_config" {
  host = harvester_virtualmachine.rancher.network_interface[index(harvester_virtualmachine.rancher.network_interface.*.name, "default")].ip_address
  depends_on = [
    harvester_virtualmachine.rancher-3
  ]
  commands = [
    "sudo sed \"s/127.0.0.1/${var.master_vip}/g\" /etc/rancher/rke2/rke2.yaml"
  ]
  user        = "kaio"
  private_key = tls_private_key.rsa_key.private_key_pem
}

