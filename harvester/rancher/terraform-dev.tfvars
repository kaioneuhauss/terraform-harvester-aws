#The login for the vms will be: User --> Kaio and Password --> Admin. If you would like to change that, change the user_vm variable and consequently the ssh-key on the cloud-config file pointing to your ownssh key.
#make sure to be in the harvester context on your kubeconfig before running terraform
#change the path under provider.tf to point to your harvester kubeconfig



#Configurations that you need to setup on Harvester before running terraform
namespace_1                   = ""
rancher_server_lb_mac         = "" #optional, in case you have more than one DNS
rancher_server_lb_windows     = "" 
nameserver                    = ""
nameserver2                   = "" #optional, in case you have more than one DNS
display_name_iso              = ""
namespace_iso                 = ""
network_vm                    = ""
network_namespace_vm          = ""
disk_storage_name             = "" #name of your storageClass


#kubernetes configurations and configurations applied by terraform

user_vm                       = "kaio"
rancher_version               = "2.10.4"
kubernetes_version            = "v1.31.7+rke2r1"
master_vip                    = "" 
master_vip_interface          = ""
rancher_server_dns            = ""
cp_hostname                   = "" #name of your node in kubernetes
cp_hostname2                  = ""
cp_hostname3                  = ""
name_1                        = "" #display name of your vm in harvester
name_2                        = ""
name_3                        = ""
hostname_1                    = "" #hostname of your vm
hostname_2                    = ""
hostname_3                    = ""
kubeconfig_filename           = "kubeconfig-dev.yaml"

