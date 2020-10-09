variable "owner" {
  description = "Owner of the project"
  type        = string
  default     = "Geovanny Lopez"
}

variable "environment" {
  description = "Used to name all the resources as part of the identifier"
  type        = string
  default     = "qa"
}

variable "region" {
  description = "Region used to deploy the template"
  type        = string
  default     = "us-east-1"
}

variable "s3_bucket" {
  description = "Bucket where lambda functions code is located"
  type        = string
  default = "geovanny-terraform-serverless"
}