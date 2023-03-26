variable "region" {
  type = string
}

variable "prefix" {
  type = string
}

variable "drain_asg_names" {
  description = "Name of Auto Scaling Group that the lambda function reacts. If you don't specify this, the lambda function will react to all of Auto Scaling Group in the account. You can use the comparison operators available in EventBridge."
  type        = list(any)
  default     = []
}
