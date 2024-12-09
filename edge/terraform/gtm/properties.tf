resource "akamai_gtm_property" "origin-web" {
  domain                      = akamai_gtm_domain.webshop.name
  name                        = "origin-web"
  type                        = "performance"
  ipv6                        = false
  score_aggregation_type      = "worst"
  stickiness_bonus_percentage = 0
  stickiness_bonus_constant   = 0
  use_computed_targets        = false
  balance_by_download_score   = false
  dynamic_ttl                 = 60
  handout_limit               = 0
  handout_mode                = "normal"
  failover_delay              = 0
  failback_delay              = 0
  ghost_demand_reporting      = false
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.cer.datacenter_id
    enabled       = true
    weight        = 1
    servers       = []
    handout_cname = var.cer_hostname
  }
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.us-west.datacenter_id
    enabled       = true
    weight        = 1
    servers       = []
    handout_cname = var.uswest_hostname
  }
  depends_on = [
    akamai_gtm_datacenter.cer,
    akamai_gtm_datacenter.us-west,
    akamai_gtm_domain.webshop
  ]
}

