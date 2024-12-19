variable "aws_public_subnet" {
  type        = list(string)
  description = "Public Subnet for Eks"
}

variable "vpc_id" {}

variable "cluster_name" {}

variable "endpoint_private_access" {}

variable "endpoint_public_access" {}

variable "public_access_cidrs" {
  type        = list(string)
  description = "Public Access Cidrs for Eks"
}

variable "node_group_name" {}

variable "scaling_desired_size" {}

variable "scaling_max_size" {}

variable "scaling_min_size" {}

variable "instance_types" {
  type        = list(string)
  description = "Instance Types for Eks"
}

variable "key_pair" {}