
#############################################
# ECS SERVICE INFO
#############################################

# output "ecs_service_name" {
#   description = "ECS Service Name"
#   value       = aws_ecs_service.app.name
# }

# output "ecs_service_arn" {
#   description = "ECS Service ARN"
#   value       = aws_ecs_service.app.id
# }

#############################################
# TASK DEFINITION INFO
#############################################

output "task_definition_arn" {
  description = "ECS Task Definition ARN"
  value       = aws_ecs_task_definition.app.arn
}


