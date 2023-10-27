

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
    aws_logs_group = aws_cloudwatch_log_group.app_logs.name 
    region         = var.aws_region
  }
}

# ECS Service
resource "aws_ecs_service" "app_service" {
  name            = var.app_name
  cluster         = var.ecs_cluster_name
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = var.launch_type
  desired_count   = var.desired_count
  platform_version = var.platform_version

  network_configuration {
    subnets          = var.subnets
    assign_public_ip = var.assign_public_ip
  }

  # Conditional load balancer settings
  dynamic "load_balancer" {
    for_each = var.create_alb ? [1] : []
    content {
      target_group_arn = var.create_alb ? aws_lb_target_group.this[0].arn : null
      container_name   = var.app_name
      container_port   = var.container_port
    }
  }

