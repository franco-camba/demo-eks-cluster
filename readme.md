# Demo EKS Cluster

This repository provisions a small Amazon EKS demo cluster with Terraform. It is intended to stand up the Kubernetes control plane, a managed node group, the IAM roles and policy attachments required by EKS, and an explicit cluster-admin access entry for the IAM role used to administer the cluster.

The configuration runs from the Terraform Cloud workspace `demo-eks-cluster` in the `fcamba-org` organization and deploys resources into AWS region `eu-west-2`.

## What This Repo Builds

- An EKS cluster named `demo-eks-cluster`.
- A managed EKS node group named `demo-eks-node-group`.
- IAM roles for the EKS control plane and worker nodes.
- AWS managed policy attachments required for EKS cluster and node group operation.
- EKS access entries that grant cluster-admin permissions to `cluster_admin_principal_arn`.
- Terraform outputs for the cluster endpoint, cluster name, certificate authority data, and an `aws eks update-kubeconfig` helper command.

## How Networking Is Supplied

The cluster does not create its own VPC or subnets. Instead, it reads subnet IDs from the Terraform Cloud workspace `demo-landing-zone-aws` using the `tfe_outputs` data source:

- `subnet_a`
- `subnet_b`
- `subnet_c`

Those subnets are then used by both the EKS control plane and the managed node group.

## Access Model

The EKS cluster is configured with `authentication_mode = "API_AND_CONFIG_MAP"`, which enables IAM-managed EKS access entries while keeping compatibility with the legacy `aws-auth` ConfigMap.

Because the cluster is created by Terraform Cloud, the interactive developer role is not necessarily the original cluster creator. The repo therefore grants cluster-admin access explicitly to the IAM role configured in `cluster_admin_principal_arn`.

## Important Variables

- `tfe_token`: Token used by the Terraform Cloud provider to read outputs from the landing zone workspace.
- `tfc_hostname`: Terraform Cloud hostname. Defaults to `app.terraform.io`.
- `tfc_organization_name`: Terraform Cloud organization name. Defaults to `fcamba-org`.
- `desired_ng_size`: Desired size for the managed node group. Defaults to `1`.
- `cluster_admin_principal_arn`: IAM role ARN that receives cluster-admin permissions through an EKS access entry.

## Expected Workflow

1. Confirm the `demo-landing-zone-aws` Terraform Cloud workspace has exported the subnet outputs required by this repo.
2. Set the Terraform Cloud variables required by this workspace, especially any sensitive token values.
3. Run a Terraform plan from Terraform Cloud or locally with the same backend configuration.
4. Apply the plan to create the EKS control plane, node group, IAM roles, and access entries.
5. Use the `kubeconfig_helper` output to configure local Kubernetes access:

   ```sh
   aws eks update-kubeconfig --region eu-west-2 --name demo-eks-cluster
   ```

## Supporting Files

- `main.tf`: Terraform Cloud backend, AWS provider, Terraform Cloud provider, and landing zone output lookup.
- `eks-cluster.tf`: EKS cluster definition and cluster-related outputs.
- `eks-node-group.tf`: Managed node group definition and scaling settings.
- `iam.tf`: IAM roles and AWS managed policy attachments for EKS.
- `eks-access.tf`: EKS access entry and cluster-admin policy association.
- `variables.tf`: Input variables for Terraform Cloud, node group sizing, and cluster admin access.
- `values.yaml`: Helm values for enabling an injector against an external Vault address; this file is supporting configuration and is not currently applied by the Terraform resources in this repo.

## End State

After a successful apply, this repo should leave you with a working demo EKS cluster in AWS, backed by existing landing-zone networking, with one managed node group ready to run workloads and an authorized IAM role able to administer the cluster.