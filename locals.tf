locals {
  vpc_cidr = "10.123.0.0/16"
}

locals {
  security_groups = {
    public = {
      name        = "public-access-sg"
      description = "Public Security Group"
      tags = {
        Name = "Public Access "
      }
      ingress = {
        ssh = {
          from_port_in = 22
          to_port_in   = 22
          protocol     = "tcp"
          cidr_blocks  = [var.access_ip]
        }
        http = {
          from_port_in = 80
          to_port_in   = 80
          protocol     = "tcp"
          cidr_blocks  = ["0.0.0.0/0"]
        }
      }
    }

    rds = {
      name        = "rds-sg"
      description = "RDS Security Group"
      tags = {
        Name = "RDS Access "
      }
      ingress = {
        mysql = {
          from_port_in = 3306
          to_port_in   = 3306
          protocol     = "tcp"
          cidr_blocks  = [local.vpc_cidr]
        }
      }
    }
  }
}