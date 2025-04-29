output "cluster_id" {
  value = rancher2_cluster_v2.aws_cluster.id
}

output "kube_config" {
  value     = rancher2_cluster_v2.aws_cluster.kube_config
  sensitive = true
}
