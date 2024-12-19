terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.81.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }

  }

  backend "local" {
    path = "terraform.tfstate"
  }
  /*backend "remote" {
		hostname = "app.terraform.io"
		organization = "module-eks-msa"

		workspaces {
			name = "AWSEKS"
		}
	}*/
}

provider "aws" {
  region                   = "ap-southeast-1"
  shared_credentials_files = ["C:/Users/tuannguyenh1/.aws/credentials"]
}