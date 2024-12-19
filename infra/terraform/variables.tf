variable "vpc_cidr" {
  type        = string
  description = "Public Subnet CIDR values"
}

variable "vpc_name" {
  type        = string
  description = "MSA Project VPC"
}

variable "cidr_public_subnet" {
  type        = list(string)
  description = "Public Subnet CIDR values for Jenkins and docker"
}

variable "cidr_public_subnet_for_eks" {
  type        = list(string)
  description = "Public Subnet CIDR values for EKS"
}

variable "ap_availability_zone" {
  type        = list(string)
  description = "Availability Zones"
}

variable "ap_availability_zone_eks" {
  type        = list(string)
  description = "Availability Zones for EKS"
}

variable "public_key" {
  type        = string
  description = "DevOps Project MSA Public key for EC2 instance"
}

variable "ec2_ami_id" {
  type        = string
  description = "DevOps Project MSA AMI Id for EC2 instance"
}
