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
  default = "A2S"
}

variable "contract_id" {
  type    = string
  default = "ctr_C-1ED34DY"
}

variable "group_id" {
  type    = string
  default = "grp_133106"
}

variable "group" {
  type    = number
  default = 133106
}

variable "email" {
  type        = string
  default     = "gmoissai@akamai.com"
}

/*
** Load balancer Origins
*/
variable "cer_hostname" {
  type        = string
  default     = "webshop-cer-devteam.lke267652.akamai-apl.net"
}
variable "uswest_hostname" {
  type        = string
  default     = "webshop-us-west-devteam.lke267652.akamai-apl.net"
}

/*
** Load balancer hostname
*/
variable "gtm_hostname" {
  type        = string
  default     = "webshop-gmoissai2.akadns.net"
}

/*
** EdgeWorkers
*/
variable "edgeworker_name" {
  type    = string
  default = "webshop-comments-gmoissai2"
}

/*
** Delivery property configuration
** Public hostname
*/
variable "property_hostname" {
  type        = string
  default     = "webshop-gmoissai2.edgesuite.net"
}
