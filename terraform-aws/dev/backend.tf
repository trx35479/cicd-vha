terraform {
  backend "s3" {
    bucket  = "unico-aws-terraform-state"
    key     = "vha/dev/terraform.tfstate"
    region  = "ap-southeast-2"
    encrypt = true
  }
}