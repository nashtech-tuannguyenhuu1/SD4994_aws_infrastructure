module "networking" {
  source               = "./modules/networking"
  vpc_cidr             = var.vpc_cidr
  vpc_name             = var.vpc_name
  cidr_public_subnet   = var.cidr_public_subnet
  cidr_public_subnet_for_eks = var.cidr_public_subnet_for_eks
  ap_availability_zone = var.ap_availability_zone
  ap_availability_zone_eks = var.ap_availability_zone_eks
}

module "security_group" {
  source              = "./modules/security-groups"
  vpc_id              = module.networking.dev_proj_msa_vpc_id
  ec2_jenkins_sg_name = "Allow port 8080 for jenkins"
}

module "jenkins" {
  source                    = "./modules/jenkins"
  ami_id                    = var.ec2_ami_id
  instance_type             = "t2.micro"
  tag_name                  = "Jenkins:Ubuntu Linux EC2"
  public_key                = var.public_key
  subnet_id                 = tolist(module.networking.dev_proj_msa_public_subnets)[0]
  sg_for_jenkins            = [module.security_group.sg_ec2_jenkins_port_8080]
  enable_public_ip_address  = true
  user_data_install_jenkins = templatefile("./modules/jenkins-runner-script/jenkins-installer.sh", {})
}

# ECR Repository for Backend
resource "aws_ecr_repository" "backend_repo" {
  name                 = "msa-backend"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}

# ECR Repository for Frontend
resource "aws_ecr_repository" "frontend_repo" {
  name                 = "msa-frontend"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}

module "eks" {
  source                  = "./modules/eks"
  aws_public_subnet       = tolist(module.networking.dev_proj_msa_private_subnets_eks)
  vpc_id                  = module.networking.dev_proj_msa_vpc_id
  cluster_name            = "proj-msa-cluster"
  endpoint_public_access  = true
  endpoint_private_access = false
  public_access_cidrs     = ["0.0.0.0/0"]
  node_group_name         = "proj-msa-node-group"
  scaling_desired_size    = 2
  scaling_max_size        = 3
  scaling_min_size        = 1
  instance_types          = ["t3.large"]
  key_pair                = "jenkins_msa"
}