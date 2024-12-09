variable "edgerc_path" {
  type    = string
  default = "~/.edgerc"
}

variable "config_section" {
  type    = string
  default = "default"
}

variable "contractid" {
  type        = string
  default     = ""
  description = "Value unknown at the time of import. Please update."
}

variable "groupid" {
  type        = string
  default     = ""
  description = "Value unknown at the time of import. Please update."
}

variable "cer_hostname" {
  type        = string
  default     = "webshop-cer-devteam.lke267652.akamai-apl.net"
}

variable "uswest_hostname" {
  type        = string
  default     = "webshop-us-west-devteam.lke267652.akamai-apl.net"
}

variable "email" {
  type        = string
  default     = "gmoissai@akamai.com"
}

variable "gtm_hostname" {
  type        = string
  default     = "webshop-gmoissai.akadns.net"
}