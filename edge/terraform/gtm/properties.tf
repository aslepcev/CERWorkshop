/*
** List of load balancers (one per Origin service)
** Comments in the file indicates where you can put actual origin IPs
*/
locals{
  //load_balancer_type = "weighted-round-robin"
  load_balancer_type = "performance"
  datacenters = [
    akamai_gtm_datacenter.de-fra-2,
    akamai_gtm_datacenter.jp-osa,
    akamai_gtm_datacenter.us-lax,
    akamai_gtm_datacenter.us-mia,
  ]
  services = toset([
    "frontend",
    "api",
    "neuralmagic",
    "hdb"
  ])
}

resource "akamai_gtm_property" "origin" {
  for_each = local.services
  domain                      = akamai_gtm_domain.webshop.name
  name                        = "origin-${each.key}"
  type                        = local.load_balancer_type
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

  dynamic "traffic_target" {
    for_each = local.datacenters
    content {
      datacenter_id = traffic_target.value.datacenter_id
      enabled       = true
      weight        = 1
      servers       = []
      handout_cname = "${var.unique_name}-${each.key}-${traffic_target.value.nickname}.akmworkshop.eu"
    }
  }
}

/*
resource "akamai_gtm_property" "origin-api" {
  domain                      = akamai_gtm_domain.webshop.name
  name                        = "origin-api"
  type                        = local.load_balancer_type
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

  // API DE
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.de-fra-2.datacenter_id
    enabled       = true
    weight        = 1
    servers       = []
    handout_cname = "webshop-cer-devteam.lke267652.akamai-apl.net"
  }
  // API JP
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.jp-osa.datacenter_id
    enabled       = true
    weight        = 1
    servers       = []
    handout_cname = "webshop-us-west-devteam.lke267652.akamai-apl.net"
  }
  // API US-LAX
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.us-lax.datacenter_id
    enabled       = true
    weight        = 1
    servers       = []
    handout_cname = "webshop-us-west-devteam.lke267652.akamai-apl.net"
  }
  // API US-MIA
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.us-mia.datacenter_id
    enabled       = true
    weight        = 1
    servers       = []
    handout_cname = "webshop-us-west-devteam.lke267652.akamai-apl.net"
  }
}

resource "akamai_gtm_property" "origin-ai" {
  domain                      = akamai_gtm_domain.webshop.name
  name                        = "origin-ai"
  type                        = local.load_balancer_type
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

  // AI DE
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.de-fra-2.datacenter_id
    enabled       = true
    weight        = 1
    servers       = []
    handout_cname = "webshop-cer-devteam.lke267652.akamai-apl.net"
  }
  // AI JP
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.jp-osa.datacenter_id
    enabled       = true
    weight        = 1
    servers       = []
    handout_cname = "webshop-us-west-devteam.lke267652.akamai-apl.net"
  }
  // AI US-LAX
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.us-lax.datacenter_id
    enabled       = true
    weight        = 1
    servers       = []
    handout_cname = "webshop-us-west-devteam.lke267652.akamai-apl.net"
  }
  // AI US-MIA
  traffic_target {
    datacenter_id = akamai_gtm_datacenter.us-mia.datacenter_id
    enabled       = true
    weight        = 1
    servers       = []
    handout_cname = "webshop-us-west-devteam.lke267652.akamai-apl.net"
  }
}
*/