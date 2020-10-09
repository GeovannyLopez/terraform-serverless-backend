variable "owner" {
  description = "Owner of the project"
  type        = string
  default     = "Geovanny Lopez"
}

variable "environment" {
  description = "Used to name all the resources as part of the identifier"
  type        = string
  default     = "dev"
}

variable "table_name" {
  description = "Name of table to be used by lambda functions"
  type        = string
}

variable "table_arn" {
  description = "Arn of table to be used by lambda functions"
  type        = string
}
