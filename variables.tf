variable "prefix" {}
variable "account_id" {}
variable "region" {}

variable "drain_asg_names" {
  type    = list(string)
  default = []
}

variable "source_zip" {
  default = "ecs-drain-lambda_1.0.6_linux_amd64.zip"
}
