variable "edgerc_path" {
  type    = string
  default = "~/.edgerc"
}

variable "config_section" {
  type    = string
  default = "default"
}

variable "contract_id" {
  type    = string
  default = "ctr_C-1ED34DY"
}

variable "group_id" {
  type    = string
  default = "grp_133106"
}

variable "email" {
  type        = string
  default     = "gmoissai@akamai.com"
}

variable "property_hostname" {
  type        = string
  default     = "webshop-gmoissai.edgesuite.net"
}

variable "gtm_hostname" {
  type        = string
  default     = "webshop-gmoissai.akadns.net"
}

variable "edgeworker_id" {
  type        = string
  default     = "91405"
}