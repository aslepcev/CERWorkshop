terraform {
  required_providers {
    akamai = {
      source  = "akamai/akamai"
      version = ">= 6.6.0"
    }
  }
  required_version = ">= 1.0"
}

resource "akamai_property" "webshop" {
  name        = var.property_name
  contract_id = var.contract_id
  group_id    = var.group_id
  product_id  = "prd_SPM"
  hostnames {
    cname_from             = var.web_hostname
    cname_to               = "webshop2024-labs.akamaiuweb.com.edgekey.net"
    cert_provisioning_type = "CPS_MANAGED"
  }
  hostnames {
    cname_from             = var.api_hostname
    cname_to               = "webshop2024-labs.akamaiuweb.com.edgekey.net"
    cert_provisioning_type = "CPS_MANAGED"
  }
  rule_format = data.akamai_property_rules_builder.webshop_rule_default.rule_format
  rules       = data.akamai_property_rules_builder.webshop_rule_default.json
}

# NOTE: Be careful when removing this resource as you can disable traffic
resource "akamai_property_activation" "webshop-staging" {
  property_id                    = akamai_property.webshop.id
  contact                        = [var.email]
  version                        = akamai_property.webshop.latest_version
  network                        = "STAGING"
  auto_acknowledge_rule_warnings = true
}
