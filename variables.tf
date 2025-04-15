variable "bucket_name" {
  description = "S3 bucket to store BTC prices"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}
