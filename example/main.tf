provider "aws" {
  region = var.region
}

module "ecs_drain" {
  source = "../"

  prefix          = var.prefix
  drain_asg_names = var.drain_asg_names
  source_zip      = var.source_zip
}
