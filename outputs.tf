output "ecs_service_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.example_service.name
}

output "example_url" {
  description = "The URL of your service"
  value       = "http://${var.domain_name}"
}

output "cloudwatch-log-group" {
  description = "Where you can find your example service logs"
  value       = aws_cloudwatch_log_group.example.name
}


