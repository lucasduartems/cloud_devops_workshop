variable "aws_account_number" {
  type = string
  description = "AWS account number"
}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "remote_backend_s3_bucket_name" {
  type = string
}

variable "tags" {
  type = map(string)

  default = {
    Environment = "production"
    Project     = "workshop"
  }
}
