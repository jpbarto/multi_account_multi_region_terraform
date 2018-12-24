variable region_code {}
variable target_account_role {}


provider "aws" {
  region = "${var.region_code}"
  assume_role = {
      role_arn = "${var.target_account_role}"
  }
}
