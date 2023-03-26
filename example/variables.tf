variable "region" {}
variable "prefix" {}
variable "drain_asg_names" {
  type    = list(any)
  default = []
}
