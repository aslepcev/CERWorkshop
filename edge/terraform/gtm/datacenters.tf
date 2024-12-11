/*
** List of Origin data centers
** latitude and longitude are mandatory for performance
** https://community.akamai.com/customers/s/article/GTM-Datacenter-Not-receiving-traffic-from-same-country
*/
resource "akamai_gtm_datacenter" "de-fra-2" {
  domain                            = akamai_gtm_domain.webshop.name
  nickname                          = "de-fra-2"
  city                              = "Frankfurt am Main"
  country                           = "DE"
  latitude                          = 50.11088
  longitude                         = 8.67949
  cloud_server_host_header_override = false
  cloud_server_targeting            = false
  depends_on = [
    akamai_gtm_domain.webshop
  ]
}

resource "akamai_gtm_datacenter" "jp-osa" {
  domain                            = akamai_gtm_domain.webshop.name
  nickname                          = "jp-osa"
  city                              = "Osaka"
  country                           = "JP"
  latitude                          = 34.75198
  longitude                         = 135.4582
  cloud_server_host_header_override = false
  cloud_server_targeting            = false
  depends_on = [
    akamai_gtm_domain.webshop
  ]
}

resource "akamai_gtm_datacenter" "us-mia" {
  domain                            = akamai_gtm_domain.webshop.name
  nickname                          = "us-mia"
  city                              = "Miami"
  state_or_province                 = "FL"
  country                           = "US"
  latitude                          = 25.775084
  longitude                         = -80.1947
  cloud_server_host_header_override = false
  cloud_server_targeting            = false
  depends_on = [
    akamai_gtm_domain.webshop
  ]
}

resource "akamai_gtm_datacenter" "us-lax" {
  domain                            = akamai_gtm_domain.webshop.name
  nickname                          = "us-lax"
  city                              = "Los Angeles"
  state_or_province                 = "CA"
  country                           = "US"
  latitude                          = 34.05224
  longitude                         = -118.24335
  cloud_server_host_header_override = false
  cloud_server_targeting            = false
  depends_on = [
    akamai_gtm_domain.webshop
  ]
}