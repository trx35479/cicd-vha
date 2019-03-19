terraform {
  backend "s3" {
    bucket  = "unico-aws-terraform-state"
    key     = "vha/story/terraform.tfstate"
    region  = "ap-southeast-2"
    encrypt = true
  }
}