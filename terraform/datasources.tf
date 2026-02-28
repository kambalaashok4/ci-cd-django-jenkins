data "aws_ecs_cluster" "existing" {
    cluster_name = "comfortable-gorilla-jslweh"
}

data "aws_ecr_repository" "service" {
  name = "cicd"
}


data "aws_vpc" "existing" {
  filter {
    name= "tag:Name"
    values = ["my-vpc"]
  }
}  

data "aws_subnets" "public1" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }
}

data "aws_subnets" "public2" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }
}


data "aws_iam_role" "ecs_task_role" {
  name = "ecsTaskExecutionRole"
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

data "aws_security_group" "ecs_service_sg" {
  filter {
    name   = "group-name"
    values = ["default"]
  }
}

data "aws_ecr_image" "service_image" {
  repository_name = "cicd"
  image_tag       = "latest"
}