variable "prefix" {}
variable "account_id" {}
variable "region" {}

variable "event_main_version" {
  description = "The version of the Lambda function that receivets the events"
  default     = "$LATEST"
}

variable "drain_asg_names" {
  type    = list(any)
  default = []
}

variable "source_zip" {
  default = "ecs-drain-lambda_1.0.6_linux_amd64.zip"
}
