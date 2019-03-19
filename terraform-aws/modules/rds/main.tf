# RDS configuration (using oracle 12c version)
# Remember to change the tags of the resources
# Include an ad-hoc variable for database name, username and password

resource "aws_db_subnet_group" "vhaDatabaseSubnetGroup" {
  count      = "${var.ENABLED == true ? 1 : 0}"
  name       = "${var.CLUSTER_NAME}-db-subnetgroup"
  subnet_ids = ["${var.SUBNET_IDS}"]

  tags = "${var.TAGS}"
}

resource "aws_db_instance" "vhaDatabase" {
  count                      = "${var.ENABLED == true ? 1 : 0}"
  identifier                 = "${var.CLUSTER_NAME}-db-instance"
  allocated_storage          = "${var.ALLOCATED_STORAGE}"
  iops                       = "${var.STORAGE_IOPS}"
  character_set_name         = "AL32UTF8"
  storage_type               = "${var.STORAGE_TYPE}"
  deletion_protection        = "${var.DELETION_PROTECTION}"
  engine                     = "${var.DB_ENGINE_TYPE}"
  engine_version             = "${var.ENGINE_VERSION}"
  instance_class             = "${var.DB_INSTANCE_CLASS}"
  license_model              = "${var.LICENSE_MODEL}"
  auto_minor_version_upgrade = "${var.MINOR_VERSION_UPGRADE}"
  name                       = "${var.DATABASE_NAME}"
  username                   = "${var.DB_USERNAME}"
  password                   = "${var.DB_PASSWORD}"
  backup_retention_period    = "${var.BACKUP_RETENTION}"
  publicly_accessible        = "${var.PUBLICLY_ACCESSIBLE}"
  monitoring_interval        = "${var.MONITORING_INTERVAL}"
  monitoring_role_arn        = "${var.MONITORING_ROLE_ARN}"
  multi_az                   = "${var.MULTI_AZ}"
  db_subnet_group_name       = "${aws_db_subnet_group.vhaDatabaseSubnetGroup.id}"
  skip_final_snapshot        = true
  vpc_security_group_ids     = ["${var.VPC_SEC_GROUPS}"]
  option_group_name          = "${aws_db_option_group.vhaDatabaseOptionGroup.id}"
  parameter_group_name       = "${aws_db_parameter_group.vhaDatabaseDefaultParameterGroup.id}"
  copy_tags_to_snapshot      = "${var.COPY_TAGS_SNAPSHOT}"

  tags = "${var.TAGS}"
}

resource "aws_db_parameter_group" "vhaDatabaseDefaultParameterGroup" {
  count       = "${var.ENABLED == true ? 1 : 0}"
  name        = "${var.CLUSTER_NAME}-oracle-parameter-group"
  description = "VHA RDS Default Parameter Group"
  family      = "${var.PARAMETER_GROUP_FAMILY}"

  tags = "${var.TAGS}"
}

resource "aws_db_option_group" "vhaDatabaseOptionGroup" {
  count                    = "${var.ENABLED == true ? 1 : 0}"
  name                     = "${var.CLUSTER_NAME}oracle-option-group"
  option_group_description = "VHA RDS Option Group"
  engine_name              = "${var.DB_ENGINE_TYPE}"
  major_engine_version     = "${var.MAJOR_ENGINE_VERSION}"

  option {
    option_name = "Timezone"

    option_settings {
      name  = "TIME_ZONE"
      value = "Australia/Sydney"
    }
  }

  tags = "${var.TAGS}"
}
