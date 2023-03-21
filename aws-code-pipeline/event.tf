resource "aws_cloudwatch_event_rule" "codecommit_push" {
  name     = "${var.code_pipeline_name}-codecommit-push"
  role_arn = aws_iam_role.event_role.arn

  event_pattern = jsonencode({
    source      = ["aws.codecommit"]
    detail-type = ["CodeCommit Repository State Change"]
    resources   = ["arn:aws:codecommit:${var.aws_region}:${var.aws_account_id}:${var.codecommit_repo_name}"]
    detail = {
      event         = ["referenceCreated", "referenceUpdated"]
      referenceType = ["branch"]
      referenceName = [var.codecommit_branch]
    }
  })
}

resource "aws_cloudwatch_event_target" "codecommit_push_target" {
  rule      = aws_cloudwatch_event_rule.codecommit_push.name
  target_id = aws_codepipeline.codepipeline.name
  arn       = aws_codepipeline.codepipeline.arn
  role_arn  = aws_iam_role.event_role.arn
}

resource "aws_cloudwatch_event_rule" "ecr_image_push" {
  name     = "${var.code_pipeline_name}-ecr-image-push"
  role_arn = aws_iam_role.event_role.arn

  event_pattern = jsonencode({
    source      = ["aws.ecr"]
    detail-type = ["ECR Image Action"]

    detail = {
      repository-name = [var.ecr_repo_name]
      image-tag       = [var.ecr_image_tag]
      action-type     = ["PUSH"]
      result          = ["SUCCESS"]
    }
  })
}

resource "aws_cloudwatch_event_target" "ecr_image_push_target" {
  rule      = aws_cloudwatch_event_rule.ecr_image_push.name
  target_id = aws_codepipeline.ecr-codepipeline.name
  arn       = aws_codepipeline.ecr-codepipeline.arn
  role_arn  = aws_iam_role.event_role.arn
}
