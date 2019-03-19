# Instantiating the module
# Reusable ec2 module will be called to instantiate the ec2-instance of matrixx and dev/systest

locals {
  ORACLE = ["oracle-se2", "12.2.0.1.ru-2018-10.rur-2018-10.r1", "12.2", "oracle-se2-12.2"]
  AURORA = ["", "", ""]
}

module "vha-dev-rds" {
  source = "../modules/rds"

  ENABLED                = "${var.ENABLE_RDS}"
  CLUSTER_NAME           = "${var.CLUSTER_NAME}"
  ALLOCATED_STORAGE      = "246"
  STORAGE_TYPE           = "io1"
  DB_ENGINE_TYPE         = "${var.DB_ENGINE == "oracle" ? element(local.ORACLE, 0) : element(local.AURORA, 0)}"
  ENGINE_VERSION         = "${var.DB_ENGINE == "oracle" ? element(local.ORACLE, 1) : element(local.AURORA, 1)}"
  DB_INSTANCE_CLASS      = "${var.DB_INSTANCE_CLASS}"
  DATABASE_NAME          = "${var.DATABASE_NAME}"
  DB_USERNAME            = "${var.DB_USERNAME}"
  DB_PASSWORD            = "${var.DB_PASSWORD}"
  BACKUP_RETENTION       = "7"
  PARAMETER_GROUP_FAMILY = "${var.DB_ENGINE == "oracle" ? element(local.ORACLE, 3) : element(local.AURORA, 3)}"
  MAJOR_ENGINE_VERSION   = "${var.DB_ENGINE == "oracle" ? element(local.ORACLE, 2) : element(local.AURORA, 2)}"
  SUBNET_IDS             = ["${data.aws_subnet_ids.unico-private-subnets.ids}"]
  VPC_SEC_GROUPS         = ["${data.aws_security_groups.unico-security-groups.ids}"]
  TAGS                   = "${map("CostCode", "68009", "Name", "VHA-DB", "Environment", "Dev", "Owner", "Rajesh Nataraj", "Project", "VHA", "Schedule", "10x5")}"
}
