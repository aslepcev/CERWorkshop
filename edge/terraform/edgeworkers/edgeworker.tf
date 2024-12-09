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
  group_id         = var.group
  resource_tier_id = 280
  local_bundle         = "./bundle.tgz"
}

resource "akamai_edgeworkers_activation" "my_activation" {
  edgeworker_id = akamai_edgeworker.edgeworker.edgeworker_id
  network       = "PRODUCTION"
  version       = akamai_edgeworker.edgeworker.version
}

output "edgeworker_id" {
  description = "Id of edgeworker"
  value       = akamai_edgeworker.edgeworker.id
}