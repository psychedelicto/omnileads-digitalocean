variable "target_droplets" {}
variable "target_port" {}
variable "region" {}
variable "name" {}
variable "vpc_id" {}
variable "tls_passthrough" {}
variable "ssl_cert" {}
variable "tenant" {
  type        = string
  default     = ""
  description = "The tenant tag"
}

variable "environment" {
  type        = string
  default     = ""
  description = "The environment tag"
}
