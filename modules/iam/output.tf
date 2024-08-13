# outputs.tf

# Output the IAM policy ARN for the EKS cluster
output "eks_cluster_policy_arn" {
  description = "The ARN of the IAM policy for the EKS cluster"
  value       = aws_iam_policy.eks_cluster_policy.arn
}

# Output the IAM role ARN for the EKS cluster
output "eks_cluster_role_arn" {
  description = "The ARN of the IAM role for the EKS cluster"
  value       = aws_iam_role.eks_cluster_role.arn
}

# Output the IAM role name for the EKS cluster
output "eks_cluster_role_name" {
  description = "The name of the IAM role for the EKS cluster"
  value       = aws_iam_role.eks_cluster_role.name
}

# Output the IAM policy attachment details
output "eks_cluster_policy_attachment_id" {
  description = "The ID of the IAM role policy attachment for the EKS cluster"
  value       = aws_iam_role_policy_attachment.eks_cluster_policy_attachment.id
}

output "cluster_role_arn" {
  description = "The ARN of the EKS cluster role"
  value       = aws_iam_role.eks_cluster_role.arn
}