# Spinning instance with datasource

resource "aws_instance" "ec2-instance" {
  ami                                  = "${var.IMAGE_ID}"
  count                                = "${element(var.ENABLED, 0) == "true" ? element(var.ENABLED, 1) : 0}"
  instance_type                        = "${var.FLAVOR}"
  subnet_id                            = "${element(var.SUBNET_ID, count.index)}"
  vpc_security_group_ids               = ["${var.VPC_SECURITY_GROUP_IDS}"]
  key_name                             = "${var.AWS_KEYPAIR}"
  user_data                            = "${var.USER_DATA}"
  instance_initiated_shutdown_behavior = "${var.SHUTDOWN_BEHAVIOR}"

  root_block_device {
    volume_type           = "${var.VOLUME_TYPE}"
    volume_size           = "${var.VOLUME_SIZE}"
    iops                  = "${var.VOLUME_IOPS}"
    delete_on_termination = true
  }

  tags = "${var.TAGS}"

  volume_tags {
    Name = "${lookup(var.TAGS, "Name")}"
  }
}
