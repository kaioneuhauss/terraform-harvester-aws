resource "rancher2_cluster_v2" "aws_cluster" {
  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version

  rke_config {
    machine_global_config = <<EOF
cloud-provider-name: aws
cni: calico
disable-kube-proxy: false
EOF

    machine_pools {
      name               = "master"
      quantity           = var.number_master
      control_plane_role = true
      etcd_role          = true
      worker_role        = false

      machine_config {
        name = rancher2_machine_config_v2.aws_master.name
        kind = rancher2_machine_config_v2.aws_master.kind
      }

      cloud_credential_secret_name = rancher2_cloud_credential.aws_cred.id
    }

    machine_pools {
      name               = "worker"
      quantity           = var.number_worker
      control_plane_role = false
      etcd_role          = false
      worker_role        = true

      machine_config {
        name = rancher2_machine_config_v2.aws_worker.name
        kind = rancher2_machine_config_v2.aws_worker.kind
      }

      cloud_credential_secret_name = rancher2_cloud_credential.aws_cred.id
    }
    machine_selector_config {
      config = yamlencode({
        cloud-provider-name     = "aws"
        kubelet-arg             = ["cloud-provider=external"]
        protect-kernel-defaults = false
      })

      machine_label_selector {
        match_expressions {
          key      = "rke.cattle.io/etcd-role"
          operator = "In"
          values   = ["true"]
        }
      }
    }

    machine_selector_config {
      config = yamlencode({
        disable-cloud-controller    = true
        kube-apiserver-arg          = ["cloud-provider=external"]
        kube-controller-manager-arg = ["cloud-provider=external"]
        kubelet-arg                 = ["cloud-provider=external"]
      })

      machine_label_selector {
        match_expressions {
          key      = "rke.cattle.io/control-plane-role"
          operator = "In"
          values   = ["true"]
        }
      }
    }

    machine_selector_config {
      config = yamlencode({
        kubelet-arg = ["cloud-provider=external"]
      })

      machine_label_selector {
        match_expressions {
          key      = "rke.cattle.io/worker-role"
          operator = "In"
          values   = ["true"]
        }
      }
    }
    additional_manifest = <<EOT
---
apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
  name: aws-cloud-controller-manager
  namespace: kube-system
spec:
  chart: aws-cloud-controller-manager
  repo: https://kubernetes.github.io/cloud-provider-aws
  targetNamespace: kube-system
  bootstrap: true
  valuesContent: |-
    hostNetworking: true
    nodeSelector:
      node-role.kubernetes.io/control-plane: "true"
    args:
      - --configure-cloud-routes=false
      - --v=5
      - --cloud-provider=aws
---
apiVersion: helm.cattle.io/v1
kind: HelmChartConfig
metadata:
  name: rke2-ingress-nginx
  namespace: kube-system
spec:
  valuesContent: |-
    controller:
      publishService:
        enabled: true
      service:
        enabled: true
EOT
  }

  depends_on = [
    rancher2_cloud_credential.aws_cred,
    rancher2_machine_config_v2.aws_master,
    rancher2_machine_config_v2.aws_worker
  ]
}
