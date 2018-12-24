variable region_code {}
variable account_role_arn {}


provider "aws" {
  region = "${var.region_code}"
  assume_role = {
      role_arn = "${var.account_role_arn}"
  }
}
