# Template para os nós masters. Os nomes das imagens precisam ser pegos através do yaml
resource "rancher2_machine_config_v2" "master" {
  generate_name = "master"
  harvester_config {
    vm_namespace = "${var.vm_namespace}"
    cpu_count    = "4"
    memory_size  = "4"

    disk_info = <<EOF
    {
      "disks": [{
        "imageName": "${var.iso_vm_namespace}/${var.iso_vm_name}",
        "size": 100,
        "bootOrder": 1
      }]
    }
    EOF

    network_info = <<EOF
    {
      "interfaces": [{
        "networkName": "${var.vlan_vm_namespace}/${var.vlan_vm_name}"
      }]
    }
    EOF

    ssh_user    = "kaio"
    user_data   = file("${path.module}/file/cloud-config-user-data.yaml")

    network_data = <<EOF
version: 2
ethernets:
  eth0:
    dhcp4: true
    gateway4: ${var.gateway}
    nameservers:
      addresses: ${var.nameserver}
EOF
  }
}

# Template para nós worker
resource "rancher2_machine_config_v2" "worker" {
  generate_name = "worker"
  harvester_config {
    vm_namespace = "${var.vm_namespace}"
    cpu_count    = "8"
    memory_size  = "8"

    disk_info = <<EOF
    {
      "disks": [{
        "imageName": "${var.iso_vm_namespace}/${var.iso_vm_name}",
        "size": 100,
        "bootOrder": 1
      }]
    }
    EOF

    network_info = <<EOF
    {
      "interfaces": [{
        "networkName": "${var.vlan_vm_namespace}/${var.vlan_vm_name}"
      }]
    }
    EOF

    ssh_user    = "kaio"
    user_data   = file("${path.module}/file/cloud-config-user-data.yaml")

    network_data = <<EOF
version: 2
ethernets:
  eth0:
    dhcp4: true
    gateway4: ${var.gateway}
    nameservers:
      addresses: ${var.nameserver}
EOF
  }
}

# Configurações do cluster Kubernetes. Para pegar a credential secret criada, execute: k get secrets -A | grep global-data ou cheque no yaml de um cluster criado
resource "rancher2_cluster_v2" "downstream" {
  name               = "${var.cluster_name}"
  kubernetes_version = "${var.kubernetes_version}"

  rke_config {
    machine_pools {
      name                         = "masters"
      quantity                     = "${var.number_masters}"
      control_plane_role           = true
      etcd_role                    = true
      worker_role                  = false
      cloud_credential_secret_name = "${var.cloud_credential_secret}"

      machine_config {
        kind = rancher2_machine_config_v2.master.kind
        name = rancher2_machine_config_v2.master.name
      }
    }

    machine_pools {
      name                         = "workers"
      quantity                     = "${var.number_workers}"
      control_plane_role           = false
      etcd_role                    = false
      worker_role                  = true
      cloud_credential_secret_name = "${var.cloud_credential_secret}"

      machine_config {
        kind = rancher2_machine_config_v2.worker.kind
        name = rancher2_machine_config_v2.worker.name
      }
    }
    additional_manifest = <<EOF
apiVersion: helm.cattle.io/v1
kind: HelmChartConfig
metadata:
  name: rke2-coredns
  namespace: kube-system
spec:
  valuesContent: |-
    nodelocal:
      enabled: true
      ip_address: "${var.dns_local}"
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
EOF

# Cloud provider apontando para o harvester. Sem essa conf vc usa o RKE2 Embedded e com ela você usa o cloud-provider harvester. doc: https://docs.harvesterhci.io/v1.4/rancher/csi-driver use  generate.sh para pegar o kubeconfig_file e adicione no diretorio files.
    machine_selector_config {
      config = jsonencode({
        cloud-provider-config = file("${path.module}/file/${var.kubeconfig_file}")
        cloud-provider-name = "harvester"
      })
    }
    machine_global_config = <<EOF
cni: "${var.cluster_cni}"
disable-kube-proxy: false
etcd-expose-metrics: false
EOF

    upgrade_strategy {
      control_plane_concurrency = "10%"
      worker_concurrency        = "10%"
    }

    etcd {
      snapshot_schedule_cron = "0 */5 * * *"
      snapshot_retention     = 5
    }

    chart_values = <<EOF
harvester-cloud-provider:
  clusterName: ${var.cluster_name}
  cloudConfigPath: /var/lib/rancher/rke2/etc/config-files/cloud-provider-config
EOF
  }
}

