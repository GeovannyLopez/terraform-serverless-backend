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

variable "get_invoke_arn" {
  description = "The invoke arn of lambda function"
  type        = string
}

variable "get_function_arn" {
  description = "Arn for GET lambda"
  type        = string
}

variable "get_function_name" {
  type        = string
}