output "execution_role_arn" {
  value = aws_iam_role.execution.arn
}

output "execution_role_name" {
  value = aws_iam_role.execution.name
}

output "task_role_arn" {
  value = var.task_role_name != "" ? aws_iam_role.task[0].arn : ""
}

output "task_role_name" {
  value = var.task_role_name != "" ? aws_iam_role.task[0].name : ""
}

