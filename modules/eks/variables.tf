# variables.tf

variable "region" {
  description = "The AWS region to deploy the resources"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs where the EKS cluster should be deployed"
  type        = list(string)
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

variable "desired_capacity" {
  description = "The desired number of worker nodes"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "The minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "The maximum number of worker nodes"
  type        = number
  default     = 3
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
