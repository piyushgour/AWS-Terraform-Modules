# outputs.tf

output "cluster_id" {
  description = "The EKS cluster ID"
  value       = aws_eks_cluster.eks_cluster.id
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS control plane"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_role_arn" {
  description = "The ARN of the EKS cluster role"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "node_group_arn" {
  description = "The ARN of the EKS node group"
  value       = aws_eks_node_group.eks_node_group.arn
}

output "node_role_arn" {
  description = "The ARN of the EKS node role"
  value       = aws_iam_role.eks_node_role.arn
}

output "kms_key_id" {
  description = "The ID of the KMS key used for EBS volume encryption"
  value       = aws_kms_key.eks_kms.id
}

output "kubeconfig" {
  description = "Kubeconfig details"
  value       = {
    host                   = aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = aws_eks_cluster.eks_cluster.certificate_authority[0].data
    token                  = data.aws_eks_cluster_auth.eks_auth.token
  }
}
