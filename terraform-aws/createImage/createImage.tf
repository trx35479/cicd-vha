# create Image from snapshot_id
# added a subdomain in configuration

provider "aws" {
  region = "ap-southeast-2"
}

data "aws_instance" "vha-base83" {
  filter {
    name   = "tag:Name"
    values = ["VHA 5080 Base to 5083"]
  }

  filter {
    name   = "tag:Owner"
    values = ["DevOps"]
  }

  filter {
    name   = "tag:Schedule"
    values = ["10x5"]
  }
}

resource "aws_ami_from_instance" "vha-5083-image" {
  name               = "vha-5083-image"
  source_instance_id = "${data.aws_instance.vha-base83.id}"

  tags {
    Name  = "VHA-MATRIXX-5083-1subdomain"
    Owner = "DevOps"
  }
}

# Expose the new ami-id 

output "vha_official_ami_id" {
  value = "${aws_ami_from_instance.vha-5083-image.id}"
}
