## DEFINE LAMBDA FUNCTION
resource "aws_lambda_function" "check_access_keys" {
  filename      = "check_access_keys.zip"
  function_name = "CheckAccessKeys"
  role          = "${aws_iam_role.access_key_check_role.arn}"
  handler       = "check_access_keys.handler"
  runtime       = "python3.7"
}

resource "aws_lambda_permission" "allow_config" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.check_access_keys.function_name}"
  principal     = "config.amazonaws.com"
}


resource "aws_config_config_rule" "access_key_rotation" {
  name = "RotateAccessKeys"

  source = {
    owner             = "CUSTOM_LAMBDA"
    source_identifier = "${aws_lambda_function.check_access_keys.arn}"

    source_detail = {
      maximum_execution_frequency = "TwentyFour_Hours"
      message_type                = "ScheduledNotification"
    }
  }
}

resource "aws_config_config_rule" "s3_bucket_versioning" {
  name = "CheckS3Versioning"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_VERSIONING_ENABLED"
  }

  depends_on = ["aws_config_configuration_recorder.config_recorder"]
}