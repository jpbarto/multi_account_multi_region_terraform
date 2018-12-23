resource "aws_config_configuration_recorder_status" "config_recorder_status" {
  name       = "${aws_config_configuration_recorder.config_recorder.name}"
  is_enabled = true
  depends_on = ["aws_config_delivery_channel.config_delivery_channel"]
}


resource "aws_s3_bucket" "config_recorder_bucket" {
  bucket = "jasbarto-config-bucket"
  force_destroy = true
}

resource "aws_config_delivery_channel" "config_delivery_channel" {
    s3_bucket_name = "${aws_s3_bucket.config_recorder_bucket.bucket}"
  depends_on = ["aws_config_configuration_recorder.config_recorder"]
}

resource "aws_config_configuration_recorder" "config_recorder" {
  name     = "config_recorder_name"
  role_arn = "${aws_iam_role.config_recorder_role.arn}"
}
