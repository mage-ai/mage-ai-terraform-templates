resource "null_resource" "ci_cd_github_action_workflow" {
  depends_on = [
    aws_ecr_repository.container_repository,
    aws_ecs_cluster.aws-ecs-cluster,
    aws_ecs_service.aws-ecs-service,
    aws_ecs_task_definition.aws-ecs-task
  ]

  provisioner "local-exec" {
    environment = {
      AWS_REGION                         = var.aws_region
      ECR_REPOSITORY                     = aws_ecr_repository.container_repository.name
      ECS_CLUSTER                        = aws_ecs_cluster.aws-ecs-cluster.name
      ECS_SERVICE                        = aws_ecs_service.aws-ecs-service.name
      ECS_TASK_DEFINITION                = aws_ecs_task_definition.aws-ecs-task.family
      ECS_TASK_DEFINITION_CONTAINER_NAME = jsondecode(aws_ecs_task_definition.aws-ecs-task.container_definitions)[0].name
    }
    command = <<EOT
      scripts/create-github-actions-workflow.sh \
      "${var.aws_region}" \
      "${aws_ecr_repository.container_repository.name}" \
      "${aws_ecs_cluster.aws-ecs-cluster.name}" \
      "${aws_ecs_service.aws-ecs-service.name}" \
      "${aws_ecs_task_definition.aws-ecs-task.family}" \
      "$(echo '${jsondecode(aws_ecs_task_definition.aws-ecs-task.container_definitions)[0].name}')"
    EOT
  }
}
