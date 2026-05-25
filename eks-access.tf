# Grant cluster-admin to the IAM role used to interact with the cluster (e.g. your
# Doormat developer role). Because this cluster is created by a Terraform Cloud run,
# the interactive role is not the cluster creator and must be authorized explicitly.
resource "aws_eks_access_entry" "developer_admin" {
  cluster_name  = aws_eks_cluster.demo-eks.name
  principal_arn = var.cluster_admin_principal_arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "developer_admin" {
  cluster_name  = aws_eks_cluster.demo-eks.name
  principal_arn = aws_eks_access_entry.developer_admin.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}
