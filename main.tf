resource "aws_ecs_task_definition" "example" {
  family                   = var.app_name
  container_definitions    = data.template_file.example.rendered
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = var.task_memory
  cpu                      = var.task_cpu
  execution_role_arn       = aws_iam_role.example_execution_role.arn
}

data "template_file" "example" {
  template = file("${path.module}/task-definition.json")

  vars = {
    name           = var.app_name
    secret_arn     = var.example_secret_arn
    aws_logs_group = aws_cloudwatch_log_group.example.name
    region         = var.aws_region
    dd_api_key_arn = data.aws_ssm_parameter.datadog_api_key.arn
  }
}

resource "aws_cloudwatch_log_group" "example" {
  name = "${var.app_name}-logs"
}

resource "aws_ecs_service" "example_service" {
  name             = var.app_name
  cluster          = var.cluster_name
  task_definition  = aws_ecs_task_definition.example.arn
  launch_type      = "FARGATE"
  desired_count    = var.desired_count
  platform_version = "1.4.0"

  network_configuration {
    subnets          = var.subnets
    assign_public_ip = var.assign_public_ip
    security_groups  = [aws_security_group.example_sg.id]
  }
}

resource "aws_security_group" "example_sg" {
  name        = "${var.app_name}-sg"
  description = "Security group for ${var.app_name}"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = ""
    to_port         = ""
    protocol        = "tcp"
    security_groups = [var.traefik_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-sg"
  }
}

