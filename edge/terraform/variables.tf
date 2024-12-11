/*
** Update with your own information
** unique_name is used to distinguish between participant, use you name or nickname to avoid collisions
** email will receive notifications on deployment completion, you may leave default value if not interested
*/
variable "unique_name" {
  type        = string
  default     = "gmoissai3"
}

variable "email" {
  type        = string
  default     = "gmoissai@akamai.com"
}


/*
** Akamai API authentication & authorization
*/
variable "edgerc_path" {
  type    = string
  default = "~/.edgerc"
}

variable "config_section" {
  type    = string
  #default = "default"
  default = "AKAU"
}

variable "contract_id" {
  type    = string
  default = "ctr_3-1A42HS1"
}

variable "group_id" {
  type    = string
  default = "grp_278981"
}
