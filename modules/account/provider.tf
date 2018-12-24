provider "aws" {
  assume_role {
    role_arn = "${var.target_account_role_arn}"
  }
}