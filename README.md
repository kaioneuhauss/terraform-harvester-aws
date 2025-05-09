# AWS & Harvester Terraform Deployments

Creator: Kaio Neuhauss dos Santos

For production environments, you can use it at your own risk.

---

## 🚀 Project Overview

This project contains Terraform configurations to deploy:

- Rancher Manager on AWS and Harvester
- Downstream Kubernetes clusters on AWS and Harvester environments

The project structure is split into two main folders:
- aws/: Terraform scripts for AWS infrastructure and Rancher Manager installation
- harvester/: Terraform scripts for Harvester environments

---

## ☁️ AWS Environment - Prerequisites

Before deploying to AWS, ensure you have:

- An IAM User with the required permissions as per Rancher's documentation:
  - https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/launch-kubernetes-with-rancher/use-new-nodes-in-an-infra-provider/create-an-amazon-ec2-cluster
  - https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/kubernetes-clusters-in-rancher-setup/set-up-cloud-providers/amazon#using-the-out-of-tree-aws-cloud-provider

- An IAM Role (example: rancher-downstream) linked to your EC2 instances with these additional policies:
  - AmazonEBSCSIDriverPolicy
  - AmazonEC2FullAccess
  - AmazonEKS_CNI_Policy
  - AmazonEKSWorkerNodePolicy
  - AmazonSSMManagedEC2InstanceDefaultPolicy
  - AmazonSSMManagedInstanceCore
  - AWSQuickSetupSSMManageResourcesExecutionPolicy
  - ElasticLoadBalancingFullAccess

Note: You may need to add additional permissions if permission-related errors occur.

- A VPC properly configured (subnets, routes, NAT, etc.)
- A Key Pair created and available under your Rancher node's home directory.

Note: Terraform will create 4 vms. 1 bastion, where you will use to access the three main rancher vms. The Rancher vms were configured using only private IPs.

---

## 🛠️ Deploying to AWS

1. Initialize the Terraform providers:
   ```bash
   terraform init
   ```

3. Plan the deployment (using a specific variable file):
   ```bash
   terraform plan -var-file="terraform-dev.tfvars" -out="plan"
   ```

   (Here, the terraform-dev.tfvars file overrides the default variables.)

5. Apply the plan:
    ```bash
   terraform apply "plan"
    ```
6. Destroy resources (order matters to avoid dependency errors):
   ```bash
   terraform destroy -target=helm_release.rancher_server -var-file="terraform-dev.tfvars"
   terraform destroy -target=helm_release.cert_manager -var-file="terraform-dev.tfvars"
   terraform destroy -var-file="terraform-dev.tfvars"
   ```

8. You will need a domain name to point to your Load Balancer.
   (For this project, Cloudflare was used as the DNS provider.)

---

## 🖥️ Harvester Environment - Prerequisites

Before deploying to Harvester, ensure you have:

- An ISO image available in your cluster.
- Proper network configuration.
- A StorageClass configured (you can use the default one or create a custom one).
- DNS Server and DHCP properly set up.
- Gateway and IP addresses defined for:
  - master-vip
  - dns-local

---

## 🛠️ Deploying to Harvester

The Terraform steps are similar to AWS but can take advantage of Terraform Workspaces to manage multiple environments (e.g., dev, prod):

1. Create new workspaces:
   ```bash
   terraform workspace new dev
   terraform workspace new prod
   ```

3. Select the workspace you want to work on:
   ```bash
   terraform workspace select dev
   ```

5. Initialize Terraform:
   ```bash
   terraform init
   ```

7. Plan the deployment:
   ```bash
   terraform plan -var-file="terraform-dev.tfvars" -out="plan"
   ```

9. Apply the plan:
   ```bash
   terraform apply "plan"
   ```

11. Destroy the environment if necessary:
   ```bash
   terraform destroy -var-file="terraform-dev.tfvars"
   ```

---

## 📚 Notes

- Always review Terraform plans before applying them.
- Ensure your credentials, IAM roles, and security groups are properly set up.
- Adjust the terraform.tfvars files according to your environment.

---

