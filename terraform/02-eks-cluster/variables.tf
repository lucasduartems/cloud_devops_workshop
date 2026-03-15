variable "aws_account_number" {
  type        = string
  description = "AWS account number"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "tags" {
  type = map(string)

  default = {
    Environment = "production"
    Project     = "workshop"
  }
}

variable "ecr_repositories" {
  type = list(string)
  default = [
    "workshop/production/frontend",
    "workshop/production/backend"
  ]
}
