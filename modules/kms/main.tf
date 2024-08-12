
# Create KMS Key for EBS Encryption
resource "aws_kms_key" "eks_kms" {
  description             = "KMS key for EKS EBS volume encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  tags                    = var.tags
}

resource "aws_kms_alias" "eks_kms_alias" {
  name          = "alias/eks-kms-key"
  target_key_id = aws_kms_key.eks_kms.id
}