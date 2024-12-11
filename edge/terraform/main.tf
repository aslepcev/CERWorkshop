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

locals{
  gtm_hostname = "webshop-${var.unique_name}.akadns.net"
  edgeworker_name = "webshop-${var.unique_name}-comments"
  property_name = "webshop-${var.unique_name}"
}

module "load_balancer" {
  source = "./gtm"

  contract_id      = var.contract_id
  group_id         = var.group_id
  email            = var.email
  unique_name      = var.unique_name
  gtm_hostname     = local.gtm_hostname
}

module "edgeworkers" {
  source = "./edgeworkers"

  group_id        = var.group_id
  edgeworker_name = local.edgeworker_name
}

module "property" {
  source = "./property"

  contract_id    = var.contract_id
  group_id       = var.group_id
  email          = var.email

  property_name = local.property_name
  web_hostname = "webshop-web-${var.unique_name}.labs.akamaiuweb.com"
  api_hostname = "webshop-api-${var.unique_name}.labs.akamaiuweb.com"

  web_origin_hostname = "origin-frontend.${local.gtm_hostname}"
  api_origin_hostname = "origin-api.${local.gtm_hostname}"
  ai_origin_hostname = "origin-nm.${local.gtm_hostname}"

  edgeworker_id = module.edgeworkers.edgeworker_id
}
