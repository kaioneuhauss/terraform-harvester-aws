# Elastic IP que será usado para o Rancher Manager:q

resource "aws_eip" "rancher_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.environment}-rancher-eip"
  }
}

# Elastic IP usado pelo NAT Gateway (para as VMs privadas acessarem a internet)
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.environment}-nat-eip"
  }
}

# Criação do NAT Gateway na subnet publica. basicamente isso garante
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.public_subnet_id

  tags = {
    Name = "${var.environment}-nat-gateway"
  }
  depends_on = [aws_eip.nat_eip]
}

# Adiciona a rota para internet via NAT Gateway na route table EXISTENTE
resource "aws_route" "add_nat_to_private_rt" {
  route_table_id         = "${var.route_table_id}" .
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
  depends_on = [aws_nat_gateway.nat_gw]
}
