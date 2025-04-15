output "s3_bucket_name" {
  value = aws_s3_bucket.btc_bucket.id
}

output "lambda_function_name" {
  value = aws_lambda_function.btc_lambda.function_name
}
