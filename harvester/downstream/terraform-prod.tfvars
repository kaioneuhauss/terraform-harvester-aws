#you need to grab that under the yaml
cloud_credential_secret              = ""

#create the access and secret key under user --> Preferences in the Rancher UI
rancher_fqdn                         = ""
rancher2_access_key                  = ""
rancher2_secret_key                  = ""


number_masters                       = 3
number_workers                       = 3

#Use an IP of your network that will server as a DNS Local for your cluster (more performance in the speed of queries)
dns_local                            = "192.168.20.150"

kubernetes_version                   = "v1.31.7+rke2r1"
cluster_name                         = ""

#If using cillium with eBPF, add the charts and configs needed
cluster_cni                          = "calico"

kubeconfig_file                      = "prod-kubeconfig"
vlan_vm_name                         = ""
vlan_vm_namespace                    = ""

#You need to grab that under the yaml file
iso_vm_name                          = ""

iso_vm_namespace                     = ""
vm_namespace	                     = ""

gateway                              = "" #gateway used by vms
nameserver                           = "" #nameserver used by vms

