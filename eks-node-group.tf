resource "aws_eks_node_group" "demo-ng" {
  cluster_name    = aws_eks_cluster.demo-eks.name
  node_group_name = "demo-eks-node-group"
  node_role_arn   = aws_iam_role.eks-ng-demo.arn
  subnet_ids      = [
      data.tfe_outputs.subnet.values.subnet_a,
      data.tfe_outputs.subnet.values.subnet_b,
      data.tfe_outputs.subnet.values.subnet_c,
      ]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ]
}