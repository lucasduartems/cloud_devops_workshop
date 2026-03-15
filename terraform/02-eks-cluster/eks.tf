resource "aws_eks_cluster" "this" {
  name    = "workshop-eks-cluster"
  version = "1.31"  # Kubernetes version

  role_arn                  = aws_iam_role.eks_cluster.arn
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]


  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  vpc_config {
    subnet_ids = data.aws_subnets.private.ids
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy,
  ]
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "workshop-eks-node-group"

  node_role_arn  = aws_iam_role.eks_cluster_ng.arn
  subnet_ids     = data.aws_subnets.private.ids
  instance_types = ["t3.medium"]
  capacity_type  = "ON_DEMAND"

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_nodegrp_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_cluster_nodegrp_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_cluster_nodegrp_AmazonEC2ContainerRegistryReadOnly,
  ]
}

