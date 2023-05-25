variable "vpc_region" {
  type        = string
}

variable "shared_config_file" {
  type        = list(string)
  # default     = ["/home/aem/.aws/config"]
}

variable "shared_credentials_file" {
  type        = list(string)
  # default     = ["/home/aem/.aws/credentials"]
}

