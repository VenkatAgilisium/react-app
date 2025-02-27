## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | terraform-aws-modules/alb/aws | 9.7.0 |
| <a name="module_ecs_cluster"></a> [ecs\_cluster](#module\_ecs\_cluster) | terraform-aws-modules/ecs/aws | 5.6.0 |
| <a name="module_ecs_service"></a> [ecs\_service](#module\_ecs\_service) | terraform-aws-modules/ecs/aws//modules/service | 5.6.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 5.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.ecs_cpu_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.ecs_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_cloudwatch_log_group.react_app_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_route53_record.react_app_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_azs"></a> [azs](#input\_azs) | Availability Zones | `list(string)` | <pre>[<br>  "us-east-1a",<br>  "us-east-1b"<br>]</pre> | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The base domain name for the application | `string` | `"reactapp.com"` | no |
| <a name="input_env"></a> [env](#input\_env) | Name of the Environemnt | `string` | n/a | yes |
| <a name="input_hosted_zone_id"></a> [hosted\_zone\_id](#input\_hosted\_zone\_id) | The Route 53 Hosted Zone ID | `string` | n/a | yes |
| <a name="input_max_task_count"></a> [max\_task\_count](#input\_max\_task\_count) | Maximum number of ECS tasks | `number` | n/a | yes |
| <a name="input_min_task_count"></a> [min\_task\_count](#input\_min\_task\_count) | Minimum number of ECS tasks | `number` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the VPC | `string` | `"nginx"` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | Private subnets | `list(string)` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | Public subnets | `list(string)` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block for the VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | The DNS name of the Application Load Balancer |
