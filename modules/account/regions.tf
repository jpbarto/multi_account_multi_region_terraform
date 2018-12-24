variable target_account_role {}

module "config_rules_ireland" {
  source = "modules/config_rules"

  region_code              = "eu-west-1"
  target_accont_role       = "${var.target_account_role}"
  config_rule_role_arn     = "${aws_iam_role.access_key_check_role.arn}"
  config_recorder_role_arn = "${aws_iam_role.config_recorder_role.arn}"
  config_recorder_bucket   = "${aws_s3_bucket.config_recorder_bucket.bucket}"
}

module "config_rules_london" {
  source = "modules/config_rules"

  region_code              = "eu-west-2"
  target_accont_role       = "${var.target_account_role}"
  config_rule_role_arn     = "${aws_iam_role.access_key_check_role.arn}"
  config_recorder_role_arn = "${aws_iam_role.config_recorder_role.arn}"
  config_recorder_bucket   = "${aws_s3_bucket.config_recorder_bucket.bucket}"
}

module "config_rules_frankfurt" {
  source = "modules/config_rules"

  region_code              = "eu-central-1"
  target_accont_role       = "${var.target_account_role}"
  config_rule_role_arn     = "${aws_iam_role.access_key_check_role.arn}"
  config_recorder_role_arn = "${aws_iam_role.config_recorder_role.arn}"
  config_recorder_bucket   = "${aws_s3_bucket.config_recorder_bucket.bucket}"
}
