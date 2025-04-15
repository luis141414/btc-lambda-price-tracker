provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "btc_bucket" {
  bucket = var.bucket_name
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject"
        ],
        Resource = "${aws_s3_bucket.btc_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_lambda_function" "btc_lambda" {
  function_name = "btc-price-tracker"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "price_checker.lambda_handler"
  runtime       = "python3.9"
  filename      = "${path.module}/lambda.zip"
  timeout       = 10
  source_code_hash = filebase64sha256("${path.module}/lambda.zip")

  environment {
    variables = {
      bucket_name = var.bucket_name
    }
  }
}

resource "aws_cloudwatch_event_rule" "every_hour" {
  name                = "btc-every-hour"
  schedule_expression = "rate(1 hour)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.every_hour.name
  target_id = "btc-lambda"
  arn       = aws_lambda_function.btc_lambda.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.btc_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_hour.arn
}
