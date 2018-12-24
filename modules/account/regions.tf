variable target_account_role_arn {}
variable account_name {}

module "config_rules_ireland" {
  source = "../config_rules"

  region_code              = "eu-west-1"
  account_role_arn         = "${var.target_account_role_arn}"
  config_rule_role_arn     = "${aws_iam_role.access_key_check_role.arn}"
  config_recorder_role_arn = "${aws_iam_role.config_recorder_role.arn}"
  config_recorder_bucket   = "${aws_s3_bucket.config_recorder_bucket.bucket}"
}

module "config_rules_london" {
  source = "../config_rules"

  region_code              = "eu-west-2"
  account_role_arn         = "${var.target_account_role_arn}"
  config_rule_role_arn     = "${aws_iam_role.access_key_check_role.arn}"
  config_recorder_role_arn = "${aws_iam_role.config_recorder_role.arn}"
  config_recorder_bucket   = "${aws_s3_bucket.config_recorder_bucket.bucket}"
}

module "config_rules_frankfurt" {
  source = "../config_rules"

  region_code              = "eu-central-1"
  account_role_arn         = "${var.target_account_role_arn}"
  config_rule_role_arn     = "${aws_iam_role.access_key_check_role.arn}"
  config_recorder_role_arn = "${aws_iam_role.config_recorder_role.arn}"
  config_recorder_bucket   = "${aws_s3_bucket.config_recorder_bucket.bucket}"
}
