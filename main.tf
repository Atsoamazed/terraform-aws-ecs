

# ECS Task Definition
resource "aws_ecs_task_definition" "app" {
  family                   = var.app_name
  network_mode             = "awsvpc"
  requires_compatibilities = [var.launch_type]
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  container_definitions = data.template_file.task-definitions.rendered
}

resource "aws_cloudwatch_log_group" "app_logs" {
  name = "${var.app_name}-logs"
}


data "template_file" "task-definitions" {
  template = file("${path.module}/task-definitions/${var.app_name}.json")
  vars = {
    name           = var.app_name
    aws_logs_group = aws_cloudwatch_log_group.${var.app_name}.name,
    region         = var.aws_region,
  }
}

# ECS Service
resource "aws_ecs_service" "app_service" {
  name            = var.app_name
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = var.launch_type
  desired_count   = var.desired_count # or another appropriate default
  platform_version = var.platform_version "1.4.0"

  network_configuration {
    subnets          = var.subnets
    assign_public_ip = var.assign_public_ip
  }

  load_balancer {
    target_group_arn = var.load_balancer_target_group_arn
    container_name   = var.app_name
    container_port   = var.container_port
  }

  # Conditional creation based on whether Route53 settings are provided
  service_registries {
    registry_arn = var.route53_record_name != null && var.route53_zone_id != null ? aws_service_discovery_service.sd_service[0].arn : null
  }

  depends_on = [
    aws_iam_role.ecs_execution_role,
    aws_iam_role_policy_attachment.ecs_task_execution_role_policy
  ]
}

# Conditional creation of service discovery resources
resource "aws_service_discovery_service" "sd_service" {
  count = var.route53_record_name != null && var.route53_zone_id != null ? 1 : 0

  name = var.app_name

  dns_config {
    namespace_id = var.route53_zone_id
    dns_records {
      ttl  = 10
      type = "A"
    }
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}


