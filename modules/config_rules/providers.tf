variable region_code {}


provider "aws" {
  region = "${var.region_code}"
}
