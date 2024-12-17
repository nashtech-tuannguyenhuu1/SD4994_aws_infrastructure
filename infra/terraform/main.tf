module "networking" {
  source               = "./modules/networking"
  vpc_cidr             = var.vpc_cidr
  vpc_name             = var.vpc_name
  cidr_public_subnet   = var.cidr_public_subnet
  eu_availability_zone = var.eu_availability_zone
}

module "security_group" {
  source              = "./modules/security-groups"
  vpc_id              = module.networking.dev_proj_msa_vpc_id
  ec2_jenkins_sg_name = "Allow port 8080 for jenkins"
}

module "jenkins" {
  source                    = "./modules/jenkins"
  ami_id                    = var.ec2_ami_id
  instance_type             = "t2.small"
  tag_name                  = "Jenkins:Ubuntu Linux EC2"
  public_key                = var.public_key
  subnet_id                 = tolist(module.networking.dev_proj_msa_public_subnets)[0]
  sg_for_jenkins            = [module.security_group.sg_ec2_jenkins_port_8080]
  enable_public_ip_address  = true
  user_data_install_jenkins = templatefile("./modules/jenkins-runner-script/jenkins-installer.sh", {})
}