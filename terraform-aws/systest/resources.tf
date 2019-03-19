# Instantiating the module
# Reusable ec2 module will be called to instantiate the ec2-instance of matrixx and dev/systest

module "vha-systest-instance-mtx" {
  source = "../modules/ec2"

  AWS_KEYPAIR            = "${var.AWS_KEYPAIR}"
  IMAGE_ID               = "${data.aws_ami.matrix5083.id}"
  FLAVOR                 = "t2.2xlarge"
  VOLUME_TYPE            = "gp2"
  VOLUME_SIZE            = "246"
  VOLUME_IOPS            = "180"
  SUBNET_ID              = ["${element(data.aws_subnet_ids.unico-private-subnets.ids, 0)}"]
  VPC_SECURITY_GROUP_IDS = "${data.aws_security_groups.unico-security-groups.ids}"
  ENABLED                = ["${var.ENABLE_MTX}", 1]
  TAGS                   = "${map("CostCode", "68009", "Environment", "Test", "Name", "${var.CLUSTER_NAME}-mtx-systest", "Owner", "Rajesh Nataraj", "Project", "VHA")}"
}

module "vha-systest-instance" {
  source = "../modules/ec2"

  AWS_KEYPAIR            = "${var.AWS_KEYPAIR}"
  IMAGE_ID               = "${data.aws_ami.RHEL7-5.id}"
  FLAVOR                 = "${var.INSTANCE_TYPE}"
  VOLUME_TYPE            = "gp2"
  VOLUME_SIZE            = "246"
  VOLUME_IOPS            = "738"
  SUBNET_ID              = ["${element(data.aws_subnet_ids.unico-private-subnets.ids, 1)}"]
  VPC_SECURITY_GROUP_IDS = "${data.aws_security_groups.unico-security-groups.ids}"
  ENABLED                = ["${var.ENABLE_TEST}", 1]
  TAGS                   = "${map("CostCode", "68009", "Environment", "Test", "Name", "MigrationTool", "Owner", "Rajesh Nataraj", "Project", "VHA", "Schedule", "10x5","auto_snapshot", "true")}"
}
