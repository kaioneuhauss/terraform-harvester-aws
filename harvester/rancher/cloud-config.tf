resource "harvester_cloudinit_secret" "cloud-config-rancher" {
   name = "cloud-config-rancher"
   namespace = "${var.namespace_1}"
   user_data    = <<EOT
   #cloud-config
   write_files:
   - path: /etc/rancher/rke2/config.yaml
     owner: root
     content: |
       token: ${var.cluster_token}
       tls-san:
         - ${var.cp_hostname}
         - ${var.cp_hostname2}
         - ${var.cp_hostname3}
         - ${var.rancher_server_lb_windows}
         - ${var.rancher_server_lb_mac}
         - ${var.master_vip}
       cni: cilium
       profile: cis
       protect-kernel-defaults: true
       kube-apiserver-arg:
       - "audit-log-maxage=30"
       - "audit-log-maxbackup=10"
       - "audit-log-maxsize=100"
       pod-security-admission-config-file: /etc/rancher/rke2/rancher-psact.yaml
       disable-kube-proxy: true
   - path: /etc/sysctl.d/90-rke2.conf
     owner: root
     content: |
       net.ipv4.conf.all.forwarding=1
       net.ipv6.conf.all.forwarding=1
   - path: /var/lib/rancher/rke2/server/manifests/rke2-cilium-config.yaml
     owner: root
     content: |
       ---
       apiVersion: helm.cattle.io/v1
       kind: HelmChartConfig
       metadata:
         name: rke2-cilium
         namespace: kube-system
       spec:
         valuesContent: |-
           kubeProxyReplacement: true
           k8sServiceHost: 127.0.0.1
           k8sServicePort: 6443
           eni:
             enabled: true
           hubble:
             enabled: true
             relay:
               enabled: true
             ui:
               enabled: true
               ingress:
                 enabled: true
                 hosts:
                   - cilium.neuhauss.com.br
   - path: /etc/rancher/rke2/rancher-psact.yaml
     owner: root
     content: |
       apiVersion: apiserver.config.k8s.io/v1
       kind: AdmissionConfiguration
       plugins:
       - configuration:
           apiVersion: pod-security.admission.config.k8s.io/v1
           defaults:
             audit: restricted
             audit-version: latest
             enforce: restricted
             enforce-version: latest
             warn: restricted
             warn-version: latest
           exemptions:
             namespaces:
             - ingress-nginx
             - kube-system
             - cattle-system
             - cattle-epinio-system
             - cattle-fleet-system
             - cattle-fleet-local-system
             - longhorn-system
             - cattle-neuvector-system
             - cattle-monitoring-system
             - rancher-alerting-drivers
             - cis-operator-system
             - cattle-csp-adapter-system
             - cattle-externalip-system
             - cattle-gatekeeper-system
             - cattle-resources-system
             - istio-system
             - cattle-istio-system
             - cattle-logging-system
             - cattle-windows-gmsa-system
             - cattle-sriov-system
             - cattle-ui-plugin-system
             - tigera-operator
             - rke2-update-so 
             - rke2-update
             - system-upgrade
             - suse-observability
             - stackstate
             - system-upgrade-controller
             - cattle-fleet-clusters-system
             - fleet-default
             - cattle-provisioning-capi-system
           kind: PodSecurityConfiguration
       name: PodSecurity
       path: ""
   package_update: true
   packages:
     - qemu-guest-agent
     - iptables
   runcmd:
   - - systemctl
     - enable
     - '--now'
     - qemu-guest-agent.service
   - - sysctl
     - -w
     - net.ipv6.conf.all.disable_ipv6=1
   - - zypper
     - -n
     - in
     - iptables
   - - zypper 
     - -n
     - in
     - open-iscsi
   - - systemctl
     - enable
     - --now
   - - systemctl 
     - start
     - iscsi
   - mkdir -p /var/lib/rancher/rke2/server/manifests/
   - wget https://kube-vip.io/manifests/rbac.yaml -O /var/lib/rancher/rke2/server/manifests/kube-vip-rbac.yaml
   - curl -sL kube-vip.io/k3s |  vipAddress=${var.master_vip} vipInterface=${var.master_vip_interface} sh | sudo tee /var/lib/rancher/rke2/server/manifests/vip.yaml
   - curl -sfL https://get.rke2.io | INSTALL_RKE2_VERSION=${var.kubernetes_version} sh -
   - sysctl -p /etc/sysctl.d/90-rke2.conf
   - cp -f /usr/local/share/rke2/rke2-cis-sysctl.conf /etc/sysctl.d/60-rke2-cis.conf
   - systemctl restart systemd-sysctl
   - useradd -r -c "etcd user" -s /sbin/nologin -M etcd -U
   - systemctl enable rke2-server.service
   - systemctl start rke2-server.service
   users:
     - name: ${var.user_vm}
       primary-group: users
       sudo: ALL=(ALL) NOPASSWD:ALL
       shell: /bin/bash
       groups: wheel
       lock_passwd: false
       ssh_authorized_keys:
       - ${tls_private_key.rsa_key.public_key_openssh}
   chpasswd: { expire: False }
   ssh_pwauth: True
   user: ${var.user_vm}
   password: $6$rounds=4096$Kxd7z5wAjIP6OiZm$s5XfMEVvdbcYPIp/qE3xidSy4CqIQmUQCi10Ub.wiAfecCu/CMUQ/jQR1q/86h.cI7VCpUSPTgpibyQZJAfcD.
    EOT
 }

