# IAM role
locals {
  source_zip = "ecs-drain-lambda_${var.source_version}_linux_amd64.zip"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "main" {
  statement {
    sid = "drain"

    actions = [
      "autoscaling:CompleteLifecycleAction",
      "ec2:DescribeInstanceAttribute",
      "ec2:DescribeInstances",
      "ecs:DescribeContainerInstances",
      "ecs:DescribeTasks",
      "ecs:ListContainerInstances",
      "ecs:ListTasks",
      "ecs:SubmitContainerStateChange",
      "ecs:UpdateContainerInstancesState",
    ]

    resources = ["*"]
  }

  statement {
    sid = "logs"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/lambda/${var.prefix}-ecs-drain:*",
    ]
  }
}

resource "aws_cloudwatch_log_group" "main" {
  name              = "/aws/lambda/${var.prefix}-ecs-drain"
  retention_in_days = 14
}

resource "aws_iam_role" "main" {
  name               = "${var.prefix}-ecs-drain-lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy" "main" {
  name   = "base"
  role   = aws_iam_role.main.id
  policy = data.aws_iam_policy_document.main.json
}

resource "aws_lambda_function" "main" {
  function_name    = "${var.prefix}-ecs-drain"
  role             = aws_iam_role.main.arn
  handler          = "ecs-drain-lambda"
  filename         = local.source_zip
  source_code_hash = filebase64sha256(local.source_zip)
  runtime          = "go1.x"
  timeout          = 60 * 15
}

resource "aws_lambda_alias" "main" {
  name             = "main"
  description      = "the main version that receives the events"
  function_name    = aws_lambda_function.main.function_name
  function_version = var.event_main_version
}

/*
{
  "version": "0",
  "id": "468fe059-f4b7-445f-bb22-2a271b94974d",
  "detail-type": "EC2 Instance-terminate Lifecycle Action",
  "source": "aws.autoscaling",
  "account": "123456789012",
  "time": "2015-12-22T18:43:48Z",
  "region": "us-east-1",
  "resources": ["arn:aws:autoscaling:us-east-1:123456789012:autoScalingGroup:59fcbb81-bd02-485d-80ce-563ef5b237bf:autoScalingGroupName/sampleASG"],
  "detail": {
    "LifecycleActionToken": "630aa23f-48eb-45e7-aba6-799ea6093a0f",
    "AutoScalingGroupName": "sampleASG",
    "LifecycleHookName": "SampleLifecycleHook-6789",
    "EC2InstanceId": "i-12345678",
    "LifecycleTransition": "autoscaling:EC2_INSTANCE_TERMINATING"
  }
}
*/

# subscribe for the entire termination events
resource "aws_cloudwatch_event_rule" "catch_all" {
  count = length(var.drain_asg_names) == 0 ? 1 : 0

  name        = "${var.prefix}-ecs-drain-catch-all"
  description = "Drain ECS Container Instances"

  event_pattern = jsonencode({
    detail-type = [
      "EC2 Instance-terminate Lifecycle Action"
    ],
    source = ["aws.autoscaling"]
  })
}

resource "aws_cloudwatch_event_rule" "specific" {
  count = length(var.drain_asg_names) > 0 ? 1 : 0

  name        = "${var.prefix}-ecs-drain"
  description = "Drain ECS Container Instances"

  event_pattern = jsonencode({
    detail-type = [
      "EC2 Instance-terminate Lifecycle Action"
    ],
    source = ["aws.autoscaling"]
    detail = {
      AutoScalingGroupName = var.drain_asg_names
    }
  })
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule = length(var.drain_asg_names) > 0 ? aws_cloudwatch_event_rule.specific[0].name : aws_cloudwatch_event_rule.catch_all[0].name
  arn  = aws_lambda_alias.main.arn
}

resource "aws_lambda_permission" "allow_events" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.main.function_name
  principal     = "events.amazonaws.com"
  source_arn    = length(var.drain_asg_names) > 0 ? aws_cloudwatch_event_rule.specific[0].arn : aws_cloudwatch_event_rule.catch_all[0].arn
  qualifier     = aws_lambda_alias.main.name
}
