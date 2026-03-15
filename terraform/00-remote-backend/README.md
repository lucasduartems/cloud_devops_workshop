# Commands

```bash
export AWS_PROFILE=workshop

export TF_VAR_aws_account_number=<ACCOUNT_NUMBER>
export TF_VAR_remote_backend_s3_bucket_name=<BUCKET_NAME>
```

# `workshop-role` IAM Role

## Permissions - AdministratorAccess

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
```

## Trusted entities

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::<ACCOUNT_NUMBER>:root"
            },
            "Action": "sts:AssumeRole",
            "Condition": {}
        }
    ]
}
```