data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }

  statement {
    effect   = "Allow"
    actions  = [
        "codecommit:CancelUploadArchive",
        "codecommit:GetBranch",
        "codecommit:GetCommit",
        "codecommit:GetRepository",
        "codecommit:GetUploadArchiveStatus",
        "codecommit:UploadArchive"
    ]
    resources = ["*"]
  }

  statement {
    effect   = "Allow"
    actions  = [
        "codedeploy:CreateDeployment",
        "codedeploy:GetApplication",
        "codedeploy:GetApplicationRevision",
        "codedeploy:GetDeployment",
        "codedeploy:GetDeploymentConfig",
        "codedeploy:RegisterApplicationRevision"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild",
        "codebuild:BatchGetBuildBatches",
        "codebuild:StartBuildBatch",
        "codebuild:CreateReportGroup",
        "codebuild:CreateReport",
        "codebuild:UpdateReport",
        "codebuild:BatchPutTestCases",
        "codebuild:BatchPutCodeCoverages"
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
        "elasticbeanstalk:*",
        "ec2:*",
        "elasticloadbalancing:*",
        "autoscaling:*",
        "cloudwatch:*",
        "s3:*",
        "sns:*",
        "cloudformation:*",
        "rds:*",
        "sqs:*",
        "ecs:*"
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
        "ecr:DescribeImages",
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "pipeline_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "build_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "${var.code_pipeline_name}-role"
  assume_role_policy = data.aws_iam_policy_document.pipeline_assume_role.json
}

resource "aws_iam_role" "codebuild_role" {
  name               = "${var.code_pipeline_name}-build-role"
  assume_role_policy = data.aws_iam_policy_document.build_assume_role.json
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "${var.code_pipeline_name}-policy"
  role   = aws_iam_role.codepipeline_role.id
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name   = "${var.code_pipeline_name}-build-policy"
  role   = aws_iam_role.codebuild_role.id
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}
