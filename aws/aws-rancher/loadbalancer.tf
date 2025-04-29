# Load Balancer para Rancher com segurança e dependência explícita do SG
resource "aws_lb" "rancher_nlb" {
  name                        = "${var.environment}-rancher-nlb"
  load_balancer_type          = "network"
  subnets                     = [var.subnet_id, var.public_subnet_id] # Subnets públicas
  enable_deletion_protection = false
  security_groups             = [aws_security_group.nlb_sg.id]
  depends_on                  = [aws_security_group.nlb_sg]

  tags = {
    Name = "${var.environment}-rancher-nlb"
  }
}

# Target Groups
resource "aws_lb_target_group" "rancher_target_group" {
  name        = "${var.environment}-targets-443"
  port        = 443
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    protocol = "TCP"
    port     = "443"
  }
}

resource "aws_lb_target_group" "rancher_target_group_6443" {
  name        = "${var.environment}-targets-6443"
  port        = 6443
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    protocol = "TCP"
    port     = "6443"
  }
}

resource "aws_lb_target_group" "rancher_target_group_9345" {
  name        = "${var.environment}-targets-9345"
  port        = 9345
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    protocol = "TCP"
    port     = "9345"
  }
}

# Listeners
resource "aws_lb_listener" "rancher_listener" {
  load_balancer_arn = aws_lb.rancher_nlb.arn
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rancher_target_group.arn
  }
  depends_on = [
    aws_lb.rancher_nlb,
    aws_lb_target_group.rancher_target_group
  ]
}

resource "aws_lb_listener" "rancher_listener_6443" {
  load_balancer_arn = aws_lb.rancher_nlb.arn
  port              = 6443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rancher_target_group_6443.arn
  }
  depends_on = [
    aws_lb.rancher_nlb,
    aws_lb_target_group.rancher_target_group_6443
  ]
}

resource "aws_lb_listener" "rancher_listener_9345" {
  load_balancer_arn = aws_lb.rancher_nlb.arn
  port              = 9345
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rancher_target_group_9345.arn
  }
  depends_on = [
    aws_lb.rancher_nlb,
    aws_lb_target_group.rancher_target_group_9345
  ]
}

# Target Group Attachments
resource "aws_lb_target_group_attachment" "rancher_targets_443_node_1" {
  target_group_arn = aws_lb_target_group.rancher_target_group.arn
  target_id        = aws_instance.rke2_node_1.id
  port             = 443
  depends_on = [
    aws_lb_target_group.rancher_target_group,
    aws_instance.rke2_node_1
  ]
}

resource "aws_lb_target_group_attachment" "rancher_targets_443_node_2" {
  target_group_arn = aws_lb_target_group.rancher_target_group.arn
  target_id        = aws_instance.rke2_node_rest[0].id
  port             = 443
  depends_on = [
    aws_lb_target_group.rancher_target_group,
    aws_instance.rke2_node_rest
  ]
}

resource "aws_lb_target_group_attachment" "rancher_targets_443_node_3" {
  target_group_arn = aws_lb_target_group.rancher_target_group.arn
  target_id        = aws_instance.rke2_node_rest[1].id
  port             = 443
  depends_on = [
    aws_lb_target_group.rancher_target_group,
    aws_instance.rke2_node_rest
  ]
}

resource "aws_lb_target_group_attachment" "rancher_targets_6443_node_1" {
  target_group_arn = aws_lb_target_group.rancher_target_group_6443.arn
  target_id        = aws_instance.rke2_node_1.id
  port             = 6443
  depends_on = [
    aws_lb_target_group.rancher_target_group_6443,
    aws_instance.rke2_node_1
  ]
}

resource "aws_lb_target_group_attachment" "rancher_targets_6443_node_2" {
  target_group_arn = aws_lb_target_group.rancher_target_group_6443.arn
  target_id        = aws_instance.rke2_node_rest[0].id
  port             = 6443
  depends_on = [
    aws_lb_target_group.rancher_target_group_6443,
    aws_instance.rke2_node_rest
  ]
}

resource "aws_lb_target_group_attachment" "rancher_targets_6443_node_3" {
  target_group_arn = aws_lb_target_group.rancher_target_group_6443.arn
  target_id        = aws_instance.rke2_node_rest[1].id
  port             = 6443
  depends_on = [
    aws_lb_target_group.rancher_target_group_6443,
    aws_instance.rke2_node_rest
  ]
}

resource "aws_lb_target_group_attachment" "rancher_targets_9345_node_1" {
  target_group_arn = aws_lb_target_group.rancher_target_group_9345.arn
  target_id        = aws_instance.rke2_node_1.id
  port             = 9345
  depends_on = [
    aws_lb_target_group.rancher_target_group_9345,
    aws_instance.rke2_node_1
  ]
}

resource "aws_lb_target_group_attachment" "rancher_targets_9345_node_2" {
  target_group_arn = aws_lb_target_group.rancher_target_group_9345.arn
  target_id        = aws_instance.rke2_node_rest[0].id
  port             = 9345
  depends_on = [
    aws_lb_target_group.rancher_target_group_9345,
    aws_instance.rke2_node_rest
  ]
}

resource "aws_lb_target_group_attachment" "rancher_targets_9345_node_3" {
  target_group_arn = aws_lb_target_group.rancher_target_group_9345.arn
  target_id        = aws_instance.rke2_node_rest[1].id
  port             = 9345
  depends_on = [
    aws_lb_target_group.rancher_target_group_9345,
    aws_instance.rke2_node_rest
  ]
}