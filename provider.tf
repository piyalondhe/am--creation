provider "aws" {
region = "eu-central-1"

}


terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "packer-tfstate"
    key            = "us-138/terraform.tfstate"
    region         = "eu-central-1"
  }
}