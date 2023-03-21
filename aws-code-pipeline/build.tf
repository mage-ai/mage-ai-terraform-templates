data "template_file" "buildspec" {
  template = file("${path.module}/buildspec.yml")
  vars = {
    container_name = var.ecs_container_name
    image_uri      = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.ecr_repo_name}:${var.ecr_image_tag}"
  }
}

resource "aws_codebuild_project" "codebuild" {
  name          = "${var.code_pipeline_name}-build-docker"
  description   = "Build docker image and push to ECR"
  build_timeout = "5"
  service_role  = aws_iam_role.codepipeline_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.aws_region
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_account_id
    }

    environment_variable {
      name  = "IMAGE_TAG"
      value = var.ecr_image_tag
    }

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = var.ecr_repo_name
    }

    environment_variable {
      name  = "AWS_ACCESS_KEY_ID"
      value = var.AWS_ACCESS_KEY_ID
    }

    environment_variable {
      name  = "AWS_SECRET_ACCESS_KEY"
      value = var.AWS_SECRET_ACCESS_KEY
    }
  }

  logs_config {
    cloudwatch_logs {}
  }

  source {
    type = "CODEPIPELINE"
  }

  source_version = "main"
}

resource "aws_codebuild_project" "ecr-codebuild" {
  name          = "${var.code_pipeline_name}-create-imagedefinitions"
  description   = "Create imagedefinitions.json file"
  build_timeout = "5"
  service_role  = aws_iam_role.codepipeline_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  logs_config {
    cloudwatch_logs {}
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = data.template_file.buildspec.rendered
  }

  source_version = "main"
}
