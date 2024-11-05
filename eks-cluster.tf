resource "aws_eks_cluster" "demo-eks" {
  name     = "demo-eks-cluster"
  role_arn = aws_iam_role.eks-cluster-demo.arn

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

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.demo-eks.certificate_authority[0].data
}