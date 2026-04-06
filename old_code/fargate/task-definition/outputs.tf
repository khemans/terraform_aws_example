output "task_definition_arn" {
  value = aws_ecs_task_definition.main.arn
}

output "task_definition_family" {
  value = aws_ecs_task_definition.main.family
}

output "task_definition_revision" {
  value = aws_ecs_task_definition.main.revision
}

