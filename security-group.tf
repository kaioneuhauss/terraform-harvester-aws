# SG do NLB
resource "aws_security_group" "nlb_sg" {
  name        = "${var.environment}-nlb-sg"
  description = "Permite comunicacao do NLB com os nodes RKE2"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.environment}-nlb-sg"
  }
}

# SG dos RKE2 Nodes
resource "aws_security_group" "rke2_sg" {
  name        = "${var.environment}-rke2-sg"
  description = "Security Group para RKE2 e Rancher com regras especificas"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.environment}-rke2-sg"
  }
}

# SG do Bastion
resource "aws_security_group" "bastion_sg" {
  name   = "${var.environment}-bastion-sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.environment}-bastion-sg"
  }
}

### Regras do NLB ###

# Libera acesso público à porta 9345 (⚠️ risco de segurança)
resource "aws_security_group_rule" "nlb_ingress_9345_public" {
  type              = "ingress"
  from_port         = 9345
  to_port           = 9345
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nlb_sg.id
}

# Libera acesso público à porta 6443 (necessário para API externa do Kubernetes)
resource "aws_security_group_rule" "nlb_ingress_6443_public" {
  type              = "ingress"
  from_port         = 6443
  to_port           = 6443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nlb_sg.id
}

# Permitir acesso externo ao Rancher UI (443)
resource "aws_security_group_rule" "nlb_ingress_443_public" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nlb_sg.id
}

# Egress do NLB
resource "aws_security_group_rule" "nlb_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nlb_sg.id
}

### Regras dos RKE2 Nodes ###

# Comunicação interna
resource "aws_security_group_rule" "rke2_ingress_internal" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["192.168.0.0/16"]
  security_group_id = aws_security_group.rke2_sg.id
}

# SSH do Bastion
resource "aws_security_group_rule" "rke2_ingress_ssh" {
  type                     = "ingress"
  from_port               = 22
  to_port                 = 22
  protocol                = "tcp"
  security_group_id       = aws_security_group.rke2_sg.id
  source_security_group_id = aws_security_group.bastion_sg.id
}

# Rancher UI 443 publico
resource "aws_security_group_rule" "rke2_ingress_443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rke2_sg.id
}

# NodePort TCP
resource "aws_security_group_rule" "rke2_ingress_nodeport_tcp" {
  type              = "ingress"
  from_port         = 30000
  to_port           = 32767
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rke2_sg.id
}

# NodePort UDP
resource "aws_security_group_rule" "rke2_ingress_nodeport_udp" {
  type              = "ingress"
  from_port         = 30000
  to_port           = 32767
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rke2_sg.id
}

# Permite acesso na porta 9345 de qualquer IP ( Risco elevado)
resource "aws_security_group_rule" "rke2_ingress_9345" {
  type              = "ingress"
  from_port         = 9345
  to_port           = 9345
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rke2_sg.id
}

# Permite acesso na porta 6443 de qualquer IP (Risco moderado, mas necessário para o kubeconfig funcionar fora da VPC)
resource "aws_security_group_rule" "rke2_ingress_6443" {
  type              = "ingress"
  from_port         = 6443
  to_port           = 6443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rke2_sg.id
}

resource "aws_security_group_rule" "rke2_ingress_6443_bastion" {
  type                     = "ingress"
  from_port               = 6443
  to_port                 = 6443
  protocol                = "tcp"
  security_group_id       = aws_security_group.rke2_sg.id
  source_security_group_id = aws_security_group.bastion_sg.id
}

# Egress geral do RKE2
resource "aws_security_group_rule" "rke2_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rke2_sg.id
}

### Regras do Bastion ###

# SSH externo
resource "aws_security_group_rule" "bastion_ingress_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion_sg.id
}

# Egress geral do Bastion
resource "aws_security_group_rule" "bastion_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion_sg.id
}
