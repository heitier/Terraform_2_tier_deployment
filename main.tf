provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Owner       = "Kanda Mateta"
      Project     = "Deploying A Highly Available 2-Tier Architecture With TF"
      Environment = terraform.workspace
    }
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.7.1"

  name = "Two_tier_vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway         = true
  single_nat_gateway         = true
  manage_default_network_acl = false
  map_public_ip_on_launch    = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "security-group" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "5.1.2"
  name        = "two_tier_sg"
  description = "Security group for webserver"
  vpc_id      = module.vpc.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Allow http"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  tags = {
    Name = "WEBSERVER SG"
  }
}

module "security-group-rds" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "5.1.2"
  name        = "rds_sg"
  description = "Security group for db"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "RDS SG"
  }
}

resource "aws_security_group_rule" "rds-ingress" {
  type                     = "ingress"
  description              = "Allow port 3306 from Webserver"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.security-group.security_group_id
  security_group_id        = module.security-group-rds.security_group_id
}

resource "aws_security_group_rule" "rds-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.security-group-rds.security_group_id
}


output "public_subnets" {
  value = module.vpc.public_subnets
}

locals {
  instances = {
    instance_1 = {
      subnet_id     = module.vpc.public_subnets[0]
      instance_type = "t2.micro"

    },
    instance_2 = {
      subnet_id     = module.vpc.public_subnets[1]
      instance_type = "t2.micro"
    }
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

module "ec2_instance" {
  source   = "terraform-aws-modules/ec2-instance/aws"
  for_each = local.instances


  name = "EC2-Nginx-${each.key}"

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = each.value.instance_type
  monitoring             = true
  vpc_security_group_ids = [module.security-group.security_group_id]
  subnet_id              = each.value.subnet_id

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
  user_data = base64encode(var.user_data_sh)
}

output "IP_1" {

  value = module.ec2_instance["instance_1"].public_ip

}

output "IP_2" {

  value = module.ec2_instance["instance_2"].public_ip
}


module "rds" {
  source                 = "terraform-aws-modules/rds/aws"
  version                = "6.5.5"
  identifier             = "demodb-terraform"
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  vpc_security_group_ids = [module.security-group-rds.security_group_id]
  monitoring_interval    = "30"
  family                 = "mysql8.0"
  major_engine_version   = "8.0"
  username               = "admin"
  password               = "securepassword"
  port                   = "3306"
  network_type           = "IPV4"
  allocated_storage      = "20"
  monitoring_role_name   = "MyRDSMonitoringRole"
  create_monitoring_role = true
  create_db_subnet_group = true
  subnet_ids             = module.vpc.private_subnets
  multi_az               = false

}