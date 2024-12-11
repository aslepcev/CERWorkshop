terraform {
  required_providers {
    akamai = {
      source  = "akamai/akamai"
      version = ">= 2.0.0"
    }
  }
  required_version = ">= 1.0"
}

resource "akamai_edgeworker" "edgeworker" {
  name             = var.edgeworker_name
  group_id         = var.group_id
  resource_tier_id = 100
  local_bundle         = "./bundle.tgz"
}

resource "akamai_edgeworkers_activation" "my_activation" {
  edgeworker_id = akamai_edgeworker.edgeworker.edgeworker_id
  network       = "STAGING"
  version       = akamai_edgeworker.edgeworker.version
}

output "edgeworker_id" {
  description = "Id of edgeworker"
  value       = akamai_edgeworker.edgeworker.id
}