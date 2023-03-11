variable "region" {}
variable "drain_asg_names" {
  type    = list(string)
  default = []
}
