output "kms_key_id" {
  description = "The ID of the KMS key used for EBS volume encryption"
  value       = aws_kms_key.eks_kms.id
}