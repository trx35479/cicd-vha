variable "AWS_REGION" {
  default = "ap-southeast-2"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "~/.ssh/id_rsa.pub"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "../files/.ec2-user.pem"
}

variable "JENKINS_PUBLIC_KEY" {
  default = "../files/dslave.pub"
}

variable "CLUSTER_NAME" {
  default = "vha"
}

variable "AWS_KEYPAIR" {
  default = "ec2-user"
}

variable "INSTANCE_TYPE" {
  default = "t2.large"
}

# can be specify as an ad-hoc --var variables

variable "DB_ENGINE" {
  default = "oracle"
}

variable "DATABASE_NAME" {
  default = "VHA"
}

variable "DB_USERNAME" {
  default = "ocsia"
}

variable "DB_PASSWORD" {
  default = "nopassword"
}

variable "DB_INSTANCE_CLASS" {
  default = "db.r5.2xlarge"
}

variable "ENABLE_RDS" {
  default = "true"
}

variable "ENABLE_MTX" {
  default = "true"
}

variable "ENABLE_DEV" {
  default = "true"
}

variable "ENABLE_TEST" {
  default = "true"
}

