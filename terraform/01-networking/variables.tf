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

variable "vpc" {
  type = object({
    name                     = string
    cidr_block               = string
    internet_gateway_name    = string
    nat_gateway_name         = string
    public_route_table_name  = string
    private_route_table_name = string

    public_subnets = list(object(
      {
        name                    = string
        cidr_block              = string
        availability_zone       = string
        map_public_ip_on_launch = bool
      }
    ))

    private_subnets = list(object(
      {
        name                    = string
        cidr_block              = string
        availability_zone       = string
      }
    ))
  })

  default = {
    name                     = "workshop-vpc"
    cidr_block               = "10.0.0.0/24"
    internet_gateway_name    = "workshop-igw"
    nat_gateway_name         = "workshop-nat"
    public_route_table_name  = "workshop-public-rt"
    private_route_table_name = "workshop-private-rt"

    public_subnets = [
      {
        name                    = "workshop-public-subnet-us-east-1a"
        cidr_block              = "10.0.0.0/26"
        availability_zone       = "us-east-1a"
        map_public_ip_on_launch = true
      },
      {
        name                    = "workshop-public-subnet-us-east-1b"
        cidr_block              = "10.0.0.64/26"
        availability_zone       = "us-east-1b"
        map_public_ip_on_launch = true
      }
    ]

    private_subnets = [
      {
        name                    = "workshop-private-subnet-us-east-1a"
        cidr_block              = "10.0.0.128/26"
        availability_zone       = "us-east-1a"
      },
      {
        name                    = "workshop-private-subnet-us-east-1b"
        cidr_block              = "10.0.0.192/26"
        availability_zone       = "us-east-1b"
      }
    ]
  }
}
