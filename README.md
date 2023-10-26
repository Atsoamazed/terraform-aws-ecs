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
| Name                        | Description                                               | Type         | Default | Required |
|-----------------------------|-----------------------------------------------------------|--------------|---------|----------|
| `app_name`                  | The name of the application used for the ECS task.        | `string`     | n/a     | yes      |
| `aws_region`                | The AWS region in which to deploy the module's resources. | `string`     | n/a     | yes      |
| `vpc_id`                    | The ID of the VPC where resources will be deployed.       | `string`     | n/a     | yes      |
| `cluster_name`              | The name of the ECS cluster where the service will run.   | `string`     | n/a     | yes      |
| `subnets`                   | A list of subnets for the task network configuration.     | `list(string)`| n/a    | yes      |
| `assign_public_ip`          | Whether to assign a public IP address to tasks.           | `bool`       | `false` | no       |
| `traefik_security_group_id` | The security group ID for Traefik.                        | `string`     | n/a     | yes      |
| `secret_arn` (optional)     | The ARN of the AWS Secrets Manager secret. Not required if no secret is used. | `string` | `""` | no |
| `task_memory`               | The amount of memory (in MiB) used by the task.           | `number`     | `1024`  | no       |
| `task_cpu`                  | The amount of CPU units used by the task.                 | `number`     | `512`   | no       |
| `desired_count`             | The number of instances of the task definition to run on the cluster. | `number` | `1`    | no       |

### Outputs

| Name                  | Description                                       |
|-----------------------|---------------------------------------------------|
| `service_url`         | The URL of your service.                          |
| `cloudwatch_log_group`| The name of the CloudWatch Log Group where you can find your logs. |


