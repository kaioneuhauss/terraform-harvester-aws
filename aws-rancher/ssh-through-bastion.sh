#!/bin/bash

# Caminho para sua chave privada
KEY_PATH="./rancher-manager-dev-keypair.pem"

# Nome do usuário da AMI
USER="ec2-user"

# Obter IPs via Terraform output
BASTION_IP=$(terraform output -raw bastion_public_ip)
NODE_IP=$(terraform output -raw rke2_node_${1}_private_ip)

if [ "$1" -eq 1 ]; then
  NODE_IP=$(terraform output -raw rke2_node_1_private_ip)
else
  INDEX=$(( $1 - 2 ))  # Node 2 → index 0 | Node 3 → index 1
  NODE_IP=$(terraform output -json rke2_node_rest_private_ips | jq -r ".[$INDEX]")
fi

echo "🔐 Conectando no rke2_node_$1 via bastion ($BASTION_IP)..."

ssh -o "ProxyCommand=ssh -i $KEY_PATH -W %h:%p $USER@$BASTION_IP" -i "$KEY_PATH" $USER@$NODE_IP
