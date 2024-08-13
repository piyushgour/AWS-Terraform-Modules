# main.tf

provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = aws_eks_cluster.eks_cluster.endpoint
  token                  = data.aws_eks_cluster_auth.eks_auth.token
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
}

# KMS Keys from KMS Module

# # Create KMS Key for EBS Encryption
# resource "aws_kms_key" "eks_kms" {
#   description             = "KMS key for EKS EBS volume encryption"
#   deletion_window_in_days = 10
#   enable_key_rotation     = true
#   tags                    = var.tags
# }

# resource "aws_kms_alias" "eks_kms_alias" {
#   name          = "alias/eks-kms-key"
#   target_key_id = aws_kms_key.eks_kms.id
# }

# Create EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  tags = var.tags

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy_attachment,
    aws_iam_role_policy_attachment.eks_vpc_resource_controller_policy_attachment
  ]
}


# Node Group IAM Role
resource "aws_iam_role" "eks_node_role" {
  name = "${var.cluster_name}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# Attach IAM Policies to Node Group Role
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy_attachment" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy_attachment" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_ec2_container_registry_readonly_policy_attachment" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Launch Template for Node Group
# resource "aws_launch_template" "eks_node_group_lt" {
#   name_prefix   = "${var.cluster_name}-lt"
#   image_id      = data.aws_ami.eks_worker_ami.id
#   instance_type = var.instance_type

#   key_name = var.key_name

#   user_data = base64encode(templatefile("${path.module}/user-data.sh", {
#     cluster_name = var.cluster_name
#   }))

#   block_device_mappings {
#     device_name = "/dev/xvda"
#     ebs {
#       volume_size           = var.ebs_volume_size
#       volume_type           = "gp2"
#       encrypted             = true
#       kms_key_id            = aws_kms_key.eks_kms.arn
#       delete_on_termination = true
#     }
#   }

#   iam_instance_profile {
#     name = aws_iam_instance_profile.eks_instance_profile.name
#   }

#   tags = var.tags
# }

resource "aws_iam_instance_profile" "eks_instance_profile" {
  name = "${var.cluster_name}-instance-profile"
  role = aws_iam_role.eks_node_role.name
  tags = var.tags
}

# EKS Node Group
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.subnet_ids
  node_group_name = "${var.cluster_name}-node-group"
  launch_template {
    id      = aws_launch_template.eks_node_group_lt.id
    version = "$Latest"
  }
  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = 1
  }

  tags = var.tags
}

# Enable EKS Add-ons
resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "coredns"
}

resource "aws_eks_addon" "kube-proxy" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "kube-proxy"
}

resource "aws_eks_addon" "calico" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "vpc-cni"
}

# Kubernetes Resources (Namespace, Ingress Controller, Filebeat)
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_deployment" "nginx_ingress" {
  metadata {
    name      = "nginx-ingress-controller"
    namespace = "kube-system"
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "nginx-ingress"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx-ingress"
        }
      }

      spec {
        container {
          name  = "nginx-ingress-controller"
          image = "k8s.gcr.io/ingress-nginx/controller:v0.47.0"
          ports {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_daemonset" "filebeat" {
  metadata {
    name      = "filebeat"
    namespace = "monitoring"
  }

  spec {
    selector {
      match_labels = {
        app = "filebeat"
      }
    }

    template {
      metadata {
        labels = {
          app = "filebeat"
        }
      }

      spec {
        container {
          name  = "filebeat"
          image = "docker.elastic.co/beats/filebeat:7.10.1"
        }
      }
    }
  }
}

data "aws_eks_cluster_auth" "eks_auth" {
  name = aws_eks_cluster.eks_cluster.name
}

data "aws_ami" "eks_worker_ami" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-1.21-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # EKS AMI account ID
}
