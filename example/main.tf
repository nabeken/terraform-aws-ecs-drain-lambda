provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

module "ecs_drain" {
  source = "../"

  prefix          = var.prefix
  drain_asg_names = var.drain_asg_names
}
