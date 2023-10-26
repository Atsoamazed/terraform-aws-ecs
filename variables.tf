variable "app_name" {
  description = "Application name for the ECS task"
  type        = string
}

variable "aws_region" {
  description = "AWS region for the deployment"
  type        = string
}

variable "example_secret_arn" {
  description = "ARN of the example secret"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where resources are deployed"
  type        = string
}

variable "cluster_name" {
  description = "ECS cluster name where the service will run"
  type        = string
}

variable "subnets" {
  description = "Subnets for the task network configuration"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Whether to assign a public IP address to tasks"
  type        = bool
}

variable "traefik_security_group_id" {
  description = "Security group ID for Traefik"
  type        = string
}

variable "task_memory" {
  description = "Memory for the task definition"
  type        = number
  default     = 1024
}

variable "task_cpu" {
  description = "CPU for the task definition"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "The number of instances of the task definition to place and keep running"
  type        = number
  default     = 1
}


