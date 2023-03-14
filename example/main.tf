provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

module "ecs_drain" {
  source = "../"

  prefix          = var.prefix
  account_id      = local.account_id
  region          = var.region
  drain_asg_names = var.drain_asg_names
}
