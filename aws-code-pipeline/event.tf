resource "aws_cloudwatch_event_rule" "ecr_image_push" {
  name     = "${var.code_pipeline_name}-ecr-image-push"
  role_arn = aws_iam_role.codepipeline_role.arn

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

resource "aws_cloudwatch_event_target" "ecr_image_push" {
  rule      = aws_cloudwatch_event_rule.ecr_image_push.name
  target_id = aws_codepipeline.ecr-codepipeline.name
  arn       = aws_codepipeline.ecr-codepipeline.arn
  role_arn  = aws_iam_role.codepipeline_role.arn
}
