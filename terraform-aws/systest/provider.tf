# Define the provider
# Note if the local host has different profile for aws accounts, 
# it should be provided in the "profile" parameters

provider "aws" {
  region = "ap-southeast-2"
  assume_role {
  role_arn = "arn:aws:iam::279459402216:role/vha-dslave-instance-role"
  }
}
