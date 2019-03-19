variable "CLUSTER_NAME" {
  default = "vha"
}

variable "ALLOCATED_STORAGE" {}

variable "STORAGE_TYPE" {
  default = "gp2" # values could be (io1, gp2 or standard (default is io1))
}

variable "STORAGE_IOPS" {
  default = 1000 
}

variable "DELETION_PROTECTION" {
  default = "false"
}

variable "DB_ENGINE_TYPE" {} # required to specify the engine (oracle, mariadb or mysql)

variable "ENGINE_VERSION" {} # required to specify the version

variable "DB_INSTANCE_CLASS" {
  default = "db.t2.micro"
}

variable "LICENSE_MODEL" {
  default = "license-included"
}

variable "MINOR_VERSION_UPGRADE" {
  default = true
}

variable "DATABASE_NAME" {} # the database name

variable "DB_USERNAME" {} # required, the username will be the schema creared in rds

variable "DB_PASSWORD" {}

variable "BACKUP_RETENTION" {
  default = "0"
}

variable "PUBLICLY_ACCESSIBLE" {
  default = false
}

variable "MULTI_AZ" {
  default = false
}

variable "MONITORING_INTERVAL" {
  default = 0 # defaull 0 is off
}

variable "MONITORING_ROLE_ARN" {
  default = ""
}

variable "SUBNET_IDS" {
  type = "list"
}

variable "VPC_SEC_GROUPS" {
  type = "list"
}

variable "COPY_TAGS_SNAPSHOT" {
  default = true
}

variable "PARAMETER_GROUP_FAMILY" {}

variable "MAJOR_ENGINE_VERSION" {}

variable "TAGS" {
  type = "map"
}

variable "ENABLED" {}
