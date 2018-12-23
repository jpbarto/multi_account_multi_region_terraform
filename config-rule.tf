resource "aws_iam_role" "access_key_check_role" {
  name = "AccessKeyCheckRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_cloudwatch_logging" {
  name = "LambdaCloudWatchLoggingPolicy"

  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_cloudwatch_logging_attach" {
  role       = "${aws_iam_role.access_key_check_role.name}"
  policy_arn = "${aws_iam_policy.lambda_cloudwatch_logging.arn}"
}

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

resource "aws_iam_role" "config_recorder_role" {
  name = "ConfigRecorderRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "access_key_check_rule_policy" {
  name = "AccessKeyCheckRulePolicy"

  role = "${aws_iam_role.config_recorder_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Action": "lambda:*",
        "Effect": "Allow",
        "Resource": "${aws_lambda_function.check_access_keys.arn}"
    },
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.config_recorder_bucket.arn}",
        "${aws_s3_bucket.config_recorder_bucket.arn}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_config_policy" {
  role       = "${aws_iam_role.config_recorder_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

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