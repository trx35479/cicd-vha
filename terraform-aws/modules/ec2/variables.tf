variable "IMAGE_ID" {}

variable "FLAVOR" {}

variable "ENABLED" {
  type = "list"
}

variable "VPC_SECURITY_GROUP_IDS" {
  type = "list"
}

variable "AWS_KEYPAIR" {}

variable "SUBNET_ID" {
  type = "list"
}

variable "TAGS" {
  type = "map"
}

variable "USER_DATA" {
  default = ""
}

variable "VOLUME_TYPE" {
  default = "standard"
}

variable "VOLUME_SIZE" {
  default = 8
}

variable "VOLUME_IOPS" {
  default = ""
}

variable "SHUTDOWN_BEHAVIOR" {
  default = "stop"
}
