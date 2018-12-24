provider "aws" {
  region = "eu-west-1"
  assume_role {
    role_arn = "${var.target_account_role_arn}"
  }
}