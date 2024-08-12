resource "aws_launch_template" "eks_node_group_lt" {
  name_prefix   = "${var.cluster_name}-lt"
  image_id      = data.aws_ami.eks_worker_ami.id
  instance_type = var.instance_type

  key_name = var.key_name

  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    cluster_name = var.cluster_name
  }))

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.ebs_volume_size
      volume_type           = "gp2"
      encrypted             = true
      kms_key_id            = aws_kms_key.eks_kms.arn
      delete_on_termination = true
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.eks_instance_profile.name
  }

  tags = var.tags
}

resource "aws_iam_instance_profile" "eks_instance_profile" {
  name = "${var.cluster_name}-instance-profile"
  role = aws_iam_role.eks_node_role.name
  tags = var.tags
}