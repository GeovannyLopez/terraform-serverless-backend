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

variable "invoke_arn" {
  description = "The invoke arn of lambda function"
  type        = string
}

variable "get_function_name" {
  description = "Function name for GET lambda"
  type        = string
}