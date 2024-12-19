vpc_cidr             = "11.0.0.0/16"
vpc_name             = "dev-proj-jenkins-ap-southeast-1-vpc"
cidr_public_subnet   = ["11.0.1.0/24"]
cidr_public_subnet_for_eks = ["11.0.2.0/24", "11.0.3.0/24"]
ap_availability_zone = ["ap-southeast-1a"]
ap_availability_zone_eks = ["ap-southeast-1a", "ap-southeast-1b"]
public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAUv27xX8QeMlrrau2rVLp/62d3/8E0Tz+iM/feC83vA harveynash\tuannguyenh1@VNNOT01586"
ec2_ami_id = "ami-06650ca7ed78ff6fa"