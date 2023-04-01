variable "prefix" {
  type        = string
  description = "A prefix used for the resources created by this module"
}

variable "event_main_version" {
  type        = string
  description = "The version of the Lambda function that receivets the events"
  default     = "$LATEST"
}

variable "drain_asg_names" {
  description = "Name of Auto Scaling Group that the lambda function reacts. If you don't specify this, the lambda function will react to all of Auto Scaling Group in the account. You can use the comparison operators available in EventBridge."
  type        = list(any)
  default     = []
}

variable "source_version" {
  type        = string
  description = "A version of the upstream release"
  default     = "1.0.7"
}
