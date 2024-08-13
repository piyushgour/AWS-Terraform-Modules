variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type for worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "The name of the key pair to use for instances"
  type        = string
}


variable "ebs_volume_size" {
  description = "The size of the EBS volumes in GB"
  type        = number
  default     = 50
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
