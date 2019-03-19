# Extract custom amis, vpc-id, security groups and subnet-ids
# centos id ami-4e9f9d2d
data "aws_availability_zones" "az" {}

data "aws_ami" "unico-centos-ami" {
  most_recent = true
  owners      = ["279459402216"]

  filter {
    name   = "name"
    values = ["Centos7.5_Unico_Java"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "RHEL7-5" {
  most_recent = true
  owners      = ["309956199498"]

  filter {
    name   = "name"
    values = ["RHEL-7.5_HVM-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "matrix5083" {
  most_recent = true
  owners      = ["279459402216"]

  filter {
    name   = "name"
    values = ["vha-5083-image"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_vpc" "unico-vpc" {
  filter {
    name   = "owner-id"
    values = ["279459402216"]
  }

  tags {
    Name  = "unico-corporate"
    Owner = "UnicoDevOps"
  }
}

data "aws_subnet_ids" "unico-private-subnets" {
  vpc_id = "${data.aws_vpc.unico-vpc.id}"

  tags {
    Name = "Unico-Corporate-Private-*"
  }
}

data "aws_security_groups" "unico-security-groups" {
  filter {
    name   = "vpc-id"
    values = ["${data.aws_vpc.unico-vpc.id}"]
  }

  tags {
    Owner = "UnicoDevOps"
  }
}
