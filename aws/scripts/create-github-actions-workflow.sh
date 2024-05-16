#!/bin/bash

AWS_REGION="$1"
ECR_REPOSITORY="$2"
ECS_CLUSTER="$3"
ECS_SERVICE="$4"
ECS_TASK_DEFINITION="$5"
CONTAINER_NAME="$6"

WORKFLOW_PATH="../../.github/workflows/build_and_deploy_to_aws_ecs.yml"
WORKFLOW_DIR=$(dirname "$WORKFLOW_PATH")

mkdir -p "$WORKFLOW_DIR"

# Create or Overwrite the YAML file with the first part
cat > $WORKFLOW_PATH << EOF
name: Deploy to Amazon ECS

on:
  push:
    branches:
      - master

env:
  AWS_REGION: $AWS_REGION
  ECR_REPOSITORY: $ECR_REPOSITORY
  ECS_CLUSTER: $ECS_CLUSTER
  ECS_SERVICE: $ECS_SERVICE
  ECS_TASK_DEFINITION: $ECS_TASK_DEFINITION
  CONTAINER_NAME: $CONTAINER_NAME

jobs:
  deploy:
    name: Deploy
    runs-on: ubuntu-latest
    environment: production

    steps:
EOF

# Append steps to the YAML file
cat >> $WORKFLOW_PATH << 'EOF'
      - name: Checkout
        uses: actions/checkout@v3

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@13d241b293754004c80624b5567555c4a39ffbe3
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ env.AWS_REGION }}

      - name: Login to Amazon ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@aaf69d68aa3fb14c1d5a6be9ac61fe15b48453a2

      - name: Build, tag, and push image to Amazon ECR
        id: build-image
        env:
          ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
          IMAGE_TAG: ${{ github.sha }}
        run: |
          docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG .
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
          echo "::set-output name=image::$ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG"

      - name: Download task definition
        run: |
          aws ecs describe-task-definition --task-definition ${{ env.ECS_TASK_DEFINITION }} \
            --query taskDefinition > task-definition.json

      - name: Fill in the new image ID in the Amazon ECS task definition
        id: task-def
        uses: aws-actions/amazon-ecs-render-task-definition@v1
        with:
          task-definition: task-definition.json
          container-name: ${{ env.CONTAINER_NAME }}
          image: ${{ steps.build-image.outputs.image }}

      - name: Deploy Amazon ECS task definition
        uses: aws-actions/amazon-ecs-deploy-task-definition@v1
        with:
          task-definition: ${{ steps.task-def.outputs.task-definition }}
          service: ${{ env.ECS_SERVICE }}
          cluster: ${{ env.ECS_CLUSTER }}
          wait-for-service-stability: true
EOF

echo "GitHub Actions workflow file created at $WORKFLOW_PATH"
