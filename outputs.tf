output "rke2_node_1_private_ip" {
  description = "IP privado do node 1"
  value       = aws_instance.rke2_node_1.private_ip
}

output "rke2_node_rest_private_ips" {
  description = "IPs privados dos nodes 2 e 3 (caso existam)"
  value       = [for node in aws_instance.rke2_node_rest : node.private_ip]
}

output "bastion_public_ip" {
  description = "IP público da instância bastion"
  value       = aws_instance.bastion.public_ip
}

output "rke2_node_1_key_name" {
  description = "Key name usado no node 1"
  value       = aws_instance.rke2_node_1.key_name
}

output "rke2_node_rest_key_names" {
  description = "Key names usados nos nodes 2 e 3"
  value       = [for node in aws_instance.rke2_node_rest : node.key_name]
}