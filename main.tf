# IAM role

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
      "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/lambda/${var.prefix}-ecs-drain",
      "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/lambda/${var.prefix}-ecs-drain/*",
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
  filename         = var.source_zip
  source_code_hash = filebase64sha256(var.source_zip)
  runtime          = "go1.x"
  timeout          = 60 * 15
}
