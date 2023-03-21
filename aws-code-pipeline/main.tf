terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = var.s3_bucket_name
}

resource "aws_codepipeline" "codepipeline" {
  name     = var.code_pipeline_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName       = var.codecommit_repo_name
        BranchName           = var.codecommit_branch
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ProjectName = aws_codebuild_project.codebuild.name
      }
    }
  }
}

resource "aws_codepipeline" "ecr-codepipeline" {
  name     = "${var.code_pipeline_name}-ecr"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "ECR_Source"

    action {
      name             = "ECR_Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "ECR"
      output_artifacts = ["ecr_docker_output"]
      version          = "1"

      configuration = {
        RepositoryName = var.ecr_repo_name
        ImageTag       = var.ecr_image_tag
      }
    }
  }

  stage {
    name = "ECR_Build"

    action {
      name             = "ECR_Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["ecr_docker_output"]
      output_artifacts = ["ecr_build_artifact"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.ecr-codebuild.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "ECR_Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["ecr_build_artifact"]
      version         = "1"

      configuration = {
        ClusterName = var.ecs_cluster_name
        ServiceName = var.ecs_service_name
      }
    }
  }
}
