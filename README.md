# terraform-aws-ecs-drain-lambda

[![Pre-Commit](https://github.com/nabeken/terraform-aws-ecs-drain-lambda/actions/workflows/pre-commit.yml/badge.svg)](https://github.com/nabeken/terraform-aws-ecs-drain-lambda/actions/workflows/pre-commit.yml)

`terraform-aws-ecs-drain-lambda` is a Terraform module that provisions [getsocial-rnd/ecs-drain-lambda](https://github.com/getsocial-rnd/ecs-drain-lambda).

## Prerequisite

You need to place a zip file that contains the `ecs-drain-lambda` binary into a terraform's working directly before invoking terraform.

You can find an example script to download the upstream zip file in `scripts` directly.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.73 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.73 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.catch_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_rule.specific](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_alias.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_alias) | resource |
| [aws_lambda_function.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_events](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_drain_asg_names"></a> [drain\_asg\_names](#input\_drain\_asg\_names) | Name of Auto Scaling Group that the lambda function reacts. If you don't specify this, the lambda function will react to all of Auto Scaling Group in the account. You can use the comparison operators available in EventBridge. | `list(any)` | `[]` | no |
| <a name="input_event_main_version"></a> [event\_main\_version](#input\_event\_main\_version) | The version of the Lambda function that receivets the events | `string` | `"$LATEST"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | A prefix used for the resources created by this module | `string` | n/a | yes |
| <a name="input_source_version"></a> [source\_version](#input\_source\_version) | A version of the upstream release | `string` | `"1.0.7"` | no |
| <a name="input_source_zip"></a> [source\_zip](#input\_source\_zip) | A path to custom zip file. You still have to place a zip file in the working directly before invoking terraform. If not specified, terraform will try to locate a zip file based on the `source_version` variable. | `string` | `""` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
