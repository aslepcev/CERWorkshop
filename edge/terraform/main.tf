terraform {
  required_providers {
    akamai = {
      source  = "akamai/akamai"
      version = ">= 6.6.0"
    }
  }
  required_version = ">= 1.0"
}

provider "akamai" {
  edgerc         = var.edgerc_path
  config_section = var.config_section
}

module "load_balancer" {
  source = "./gtm"

  edgerc_path     = var.edgerc_path
  config_section  = var.config_section
  contractid      = var.contract_id
  groupid         = var.group_id
  cer_hostname    = var.cer_hostname
  uswest_hostname = var.uswest_hostname
  email           = var.email
  gtm_hostname    = var.gtm_hostname
}

module "edgeworkers" {
  source = "./edgeworkers"

  edgerc_path     = var.edgerc_path
  config_section  = var.config_section
  group           = var.group
  edgeworker_name = var.edgeworker_name
}

module "property" {
  source = "./property"

  edgerc_path    = var.edgerc_path
  config_section = var.config_section
  contract_id    = var.contract_id
  group_id       = var.group_id
  email          = var.email

  gtm_hostname  = var.gtm_hostname
  edgeworker_id = module.edgeworkers.edgeworker_id

  property_hostname = var.property_hostname

  depends_on = [module.load_balancer, module.edgeworkers]
}
