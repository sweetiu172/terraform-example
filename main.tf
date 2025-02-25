terraform {
  cloud {

    organization = "devops-course-tuan"

    workspaces {
      tags = ["project", "aws"]
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}


module "alb" {
  source   = "./modules/load_balancers"
  alb_name = "hung-alb"
}

module "instances" {
  source     = "./modules/instances"
  depends_on = [module.alb]

  instance_name    = var.instance_name
  instance_type    = var.instance_type
  alb_sg_id        = module.alb.lb_sg
  target_group_arn = module.alb.target_group_arn
}
