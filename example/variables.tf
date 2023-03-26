variable "region" {
  description = "AWS Region where the lambda function will be deployed"
  type        = string
}

variable "prefix" {
  description = "A prefix used for resources created by this module"
  type        = string
}

variable "drain_asg_names" {
  description = "Name of Auto Scaling Group that the lambda function reacts. If you don't specify this, the lambda function will react to all of Auto Scaling Group in the account. You can use the comparison operators available in EventBridge."
  type        = list(any)
  default     = []
}
