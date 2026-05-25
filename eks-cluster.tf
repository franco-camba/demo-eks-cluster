resource "aws_eks_cluster" "demo-eks" {
  name     = "demo-eks-cluster"
  role_arn = aws_iam_role.eks-cluster-demo.arn

  # Enable IAM-managed access entries (keeps the legacy aws-auth ConfigMap working too).
  # bootstrap_cluster_creator_admin_permissions defaults to true, so the identity that
  # runs this apply (the TFC workspace role) is granted admin automatically.
  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  vpc_config {
    subnet_ids = [
      data.tfe_outputs.subnet.values.subnet_a,
      data.tfe_outputs.subnet.values.subnet_b,
      data.tfe_outputs.subnet.values.subnet_c,
    ]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController,
  ]
}

output "endpoint" {
  value = aws_eks_cluster.demo-eks.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.demo-eks.name
}

output "kubeconfig_helper" {
  value = "aws eks update-kubeconfig --region eu-west-2 --name ${aws_eks_cluster.demo-eks.name}"
}


output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.demo-eks.certificate_authority[0].data
}