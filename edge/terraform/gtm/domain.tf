terraform {
  required_providers {
    akamai = {
      source  = "akamai/akamai"
      version = ">= 6.0.0"
    }
  }
  required_version = ">= 1.0"
}

resource "akamai_gtm_domain" "webshop" {
  contract                  = var.contract_id
  group                     = var.group_id
  name                      = var.gtm_hostname
  type                      = "basic"
  comment                   = "pushed from terraform"
  email_notification_list   = [var.email]
  default_timeout_penalty   = 25
  // Allow all traffic to go to a single DC, Geography takes highest precedence
  load_imbalance_percentage = 100
  default_error_penalty     = 75
  cname_coalescing_enabled  = false
  load_feedback             = false
  end_user_mapping_enabled  = false
  sign_and_serve            = false
}
