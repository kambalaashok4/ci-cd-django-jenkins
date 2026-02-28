
resource "aws_ecs_task_definition" "app" {
  family                   = "my-app"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = data.aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "app"
      #image = "${data.aws_ecr_repository.service.repository_url}:${data.aws_ecr_image.service_image.image_tag}"
      image = "${data.aws_ecr_repository.service.repository_url}:${var.image_tag}"
      
      essential = true
      portMappings = [
        {
          containerPort = 8000
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "app" {
  name            = "my-app-service"
  cluster         = data.aws_ecs_cluster.existing.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    
    subnets = [data.aws_subnets.public1.ids[0], data.aws_subnets.public2.ids[0]]
    security_groups = [data.aws_security_group.ecs_service_sg.id]
    assign_public_ip = true
  }
}