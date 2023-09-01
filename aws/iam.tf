# iam.tf | IAM Role Policies

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "${var.app_name}-execution-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags = merge(
    var.common_tags,
    {
      Name = "${var.app_name}-iam-role"
    }
  )
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "secrets_read_only" {
  name        = "SecretsReadOnly"
  description = "Read-only access to AWS Secrets Manager"
  tags = merge(
    var.common_tags,
    {
      Name = "${var.app_name}-secrets-read-only"
    }
  )
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "attach_secrets_manager_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = aws_iam_policy.secrets_read_only.arn
}

resource "aws_iam_policy" "mage_s3_bucket_policy" {
  name        = "MageS3BucketPolicy"
  description = "Access Mage S3 Bucket"
  tags = merge(
    var.common_tags,
    {
      Name = "${var.app_name}-mage-s3-bucket-policy"
    }
  )
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": "${aws_s3_bucket.bucket.arn}/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_mage_s3_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = aws_iam_policy.mage_s3_bucket_policy.arn
}

resource "aws_iam_policy" "mage_user_policy" {
  name = "MageUserPolicy"
  description = "Mage user policy"
  tags = merge(
    var.common_tags,
    {
      Name = "${var.app_name}-mage-user-policy"
    }
  )
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:BatchCheckLayerAvailability",
                "ecr:CompleteLayerUpload",
                "ecr:GetAuthorizationToken",
                "ecr:InitiateLayerUpload",
                "ecr:PutImage",
                "ecr:UploadLayerPart",
                "ecs:DeregisterTaskDefinition",
                "ecs:DescribeClusters",
                "ecs:DescribeServices",
                "ecs:DescribeTaskDefinition",
                "ecs:RegisterTaskDefinition",
                "ecs:UpdateService"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_user" "mage_user" {
  name = "mage-user"
  tags = merge(
    var.common_tags,
    {
      Name = "${var.app_name}-mage-user"
    }
  )
}

resource "aws_iam_user_policy_attachment" "attach_mage_user_policy" {
  user       = aws_iam_user.mage_user.name
  policy_arn = aws_iam_policy.mage_user_policy.arn
}

resource "aws_iam_user_policy_attachment" "attach_mage_s3_bucket_policy" {
  user       = aws_iam_user.mage_user.name
  policy_arn = aws_iam_policy.mage_s3_bucket_policy.arn
}




# resource "aws_iam_role" "lambda_role" {
#   name   = "${var.app_name}-lambda-role"
#   assume_role_policy = <<EOF
# {
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Action": "sts:AssumeRole",
#      "Principal": {
#        "Service": "lambda.amazonaws.com"
#      },
#      "Effect": "Allow",
#      "Sid": ""
#    }
#  ]
# }
# EOF
# }

# resource "aws_iam_policy" "iam_policy_for_lambda" {
#  name         = "${var.app_name}_policy_for_lambda_role"
#  path         = "/"
#  description  = "IAM Policy for managing ${var.app_name} lambda role"
#  policy = <<EOF
# {
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Action": [
#        "logs:CreateLogGroup",
#        "logs:CreateLogStream",
#        "logs:PutLogEvents"
#      ],
#      "Resource": "arn:aws:logs:*:*:*",
#      "Effect": "Allow"
#    }
#  ]
# }
# EOF
# }

# resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_lambda_role" {
#  role        = aws_iam_role.lambda_role.name
#  policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
# }
