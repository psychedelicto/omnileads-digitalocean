
variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "ip_range" {
  type        = string
  default     = ""
  description = "VPS CIDR for customer components"
}

variable "enable_vpc" {
  type        = bool
  default     = true
  description = "A boolean flag to enable/disable vpc."
}

variable "region" {
  type        = string
  description = "The region to create VPC, like ``london-1`` , ``bangalore-1`` ,``newyork-3`` ``toronto-1``. "
}

variable "description" {
  type        = string
  default     = "VPC"
  description = "A free-form text field up to a limit of 255 characters to describe the VPC."
}

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
