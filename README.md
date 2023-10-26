## terraform-aws-ecs
This Terraform module deploys a service on AWS ECS (Elastic Container Service). The module sets up the necessary resources for a secure and efficient deployment, including the ECS service, task definition, IAM roles, and security groups. It supports the choice between FARGATE and EC2 launch types and optional integration with a load balancer and Route53 for service discovery.

#### Requirements

Terraform 1.30.0 or newer
AWS provider

#### Features
- Configurable ECS service using Fargate for hassle-free scaling and management.
- Security best practices using IAM roles and security groups.
- Optional integration with AWS Secrets Manager for secure credential storage.
- CloudWatch Logs integration for easy monitoring and logging.

### Usage
Include this module in your Terraform configuration with the following steps:

Add the module to your Terraform configuration:

```
module "example" {
  source                    = "path/to/this/module"
  app_name                  = "example-app"
  aws_region                = "us-east-1"
  vpc_id                    = var.vpc_id
  cluster_name              = var.cluster_name
  subnets                   = [var.subnets]
  assign_public_ip          = false
  traefik_security_group_id = var.security_groupid
  # Optional: secret_arn can be provided if necessary
  # secret_arn = var.secret_arn
}

```
Run `terraform init` and `terraform apply` to deploy the service.
### Variables
## Inputs

The following are the input variables for the module:

| Name                      | Description                                                   | Type          | Default                                     | Required |
|---------------------------|---------------------------------------------------------------|---------------|---------------------------------------------|:--------:|
| `app_name`                | Application name for the ECS task                             | `string`      | n/a                                         |    yes   |
| `account_name`            | The AWS account that hosts the resources in this workspace    | `string`      | `""`                                        |    no    |
| `aws_region`              | The AWS region that hosts the resources in this workspace     | `string`      | `"us-east-1"`                               |    no    |
| `domain_name`             | The domain name used for the service                          | `string`      | `` |    no    |
| `secret_arn`              | ARN of the  secret                                     | `string`      | n/a                                         |    yes   |
| `vpc_id`                  | ID of the VPC where resources are deployed                    | `string`      | n/a                                         |    yes   |
| `cluster_name`            | ECS cluster name where the service will run                   | `string`      | n/a                                         |    yes   |
| `subnets`                 | Subnets for the task network configuration                    | `list(string)`| n/a                                         |    yes   |
| `assign_public_ip`        | Whether to assign a public IP address to tasks                | `bool`        | n/a                                         |    yes   |
| `traefik_security_group_id`| Security group ID for Traefik                                | `string`      | n/a                                         |    yes   |
| `task_memory`             | Memory for the task definition                                | `number`      | `1024`                                      |    no    |
| `task_cpu`                | CPU for the task definition                                   | `number`      | `512`                                       |    no    |
| `desired_count`           | The number of instances of the task definition to place and keep running | `number` | `1`                                     |    no    |
| `platform_version`        | The platform version for Fargate                              | `string`      | `"1.40.0"`                                  |    no    |



### Outputs

| Name                  | Description                                       |
|-----------------------|---------------------------------------------------|
| `service_url`         | The URL of your service.                          |
| `cloudwatch_log_group`| The name of the CloudWatch Log Group where you can find your logs. |


