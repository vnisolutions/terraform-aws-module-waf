variable "region" {
  description = "The region for create resource aws"
  type        = string
}

variable "env" {
  description = "Enviroment for application such as prod, stg, dev"
  type        = string
}

variable "project_name" {
  description = "Project name application"
  type        = string
}

variable "rate_limit" {
  description = "Rate allow access per 5 min."
  type        = number
  default     = 100
}

variable "whitelist_ip" {
  description = "A list allow access to application"
  type        = list(string)
  default     = []
}
