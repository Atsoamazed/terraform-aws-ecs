## terraform-aws-ecs
This Terraform module deploys a service on AWS ECS (Elastic Container Service). The module sets up the necessary resources, including the ECS service, task definition, IAM roles, and security groups. It supports the choice between FARGATE and EC2 launch types and optional integration with a load balancer and Route53 for service discovery.

#### Requirements

Terraform 1.30.0 or newer
AWS provider

#### Features
- Configurable ECS service using Fargate for hassle-free scaling and management.
- Security best practices using IAM roles and security groups.
- Optional integration with AWS Secrets Manager for secure credential storage.
- CloudWatch Logs integration for easy monitoring and logging.

### Variables Inputs

The following are the input variables for the module:

| Name                | Description                                               | Type         | Default                                         | Required |
|-------------------------|-----------------------------------------------------------|--------------|-------------------------------------------------|----------|
| `app_name`              | Application name for the ECS task                         | `string`     | N/A                                             | Yes      |
| `account_name`          | The AWS account that hosts the resources in this workspace| `string`     | `""`                                            | No       |
| `aws_region`            | The AWS region that hosts the resources in this workspace | `string`     | `"us-east-1"`                                   | No       |
| `domain_name`           | Domain name for the service                               | `string`     | `""`                                             | No |
| `secret_arn`            | ARN of the example secret                                 | `string`     | N/A                                             | Yes      |
| `vpc_id`                | ID of the VPC where resources are deployed                | `string`     | N/A                                             | Yes      |
| `cluster_name`          | ECS cluster name where the service will run               | `string`     | N/A                                             | Yes      |
| `subnets`               | Subnets for the task network configuration                | `list(string)`| N/A                                             | Yes      |
| `assign_public_ip`      | Whether to assign a public IP address to tasks            | `bool`       | N/A                                             | Yes      |
| `traefik_sgid`          | Security group ID for Traefik                             | `string`     | `""`                                            | No       |
| `task_memory`           | Memory for the task definition                            | `number`     | `1024`                                          | No       |
| `task_cpu`              | CPU for the task definition                               | `number`     | `512`                                           | No       |
| `desired_count`         | The number of instances of the task definition to place and keep running | `number` | `1`                                   | No       |
| `platform_version`      | The platform version for fargate                          | `string`     | `"1.40.0"`                                      | No       |
| `create_alb`            | Determines whether an ALB should be created               | `bool`       | `false`                                         | No       |
| `create_route53_record` | Determines whether a Route53 record should be created     | `bool`       | `false`                                         | No       |
| `container_port`        | Container port for the ECS security group                 | `number`     |  N/A                                            | Yes   |




### Outputs

| Name                  | Description                                       |
|-----------------------|---------------------------------------------------|
| `service_url`         | The URL of your service.                          |
| `cloudwatch_log_group`| The name of the CloudWatch Log Group where you can find your logs. |


### Usage

```
module "example" {
  source                      = "path/to/this/module"
  app_name                    = "example-app"
  aws_region                  = "us-east-1"
  vpc_id                      = vpc-0e4abcd1234example"
  cluster_name                = "my-ecs-cluster"
  subnets                     =  ["subnet-01234abexamplef", "subnet-0a1b2c3d4e5example"]
  assign_public_ip            = false
  traefik_security_group_id   = var.security_group
  secret_arn                  = var.secret_arn # used if you need to pass secret token
}
```

Example of creating an optional load balancer and route53
```
module "my_app_ecs" {
  source = "./modules/my-ecs-module"  # Path to your module

  app_name               = var.app_name
  aws_region             = var.aws_region
  vpc_id                 = var.vpc_id
  cluster_name           = var.cluster_name
  subnets                = [var.subnets]
  assign_public_ip       = true
  create_alb             = true
  create_route53_record  = true
  domain_name            = var.domain_name
  task_memory            = var.task_memory
  task_cpu               = var.task_cpu
  desired_count          = var.desired_count
  platform_version       = var.platform_version
}
```
Run `terraform init`, `terraform plan` and `terraform apply` to deploy the service.


