resource "akamai_gtm_datacenter" "cer" {
  domain                            = akamai_gtm_domain.webshop.name
  nickname                          = "cer"
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

resource "akamai_gtm_datacenter" "us-west" {
  domain                            = akamai_gtm_domain.webshop.name
  nickname                          = "us-west"
  city                              = "Fremont"
  state_or_province                 = "CA"
  country                           = "US"
  latitude                          = 37.5502
  longitude                         = -121.98083
  cloud_server_host_header_override = false
  cloud_server_targeting            = false
  depends_on = [
    akamai_gtm_domain.webshop
  ]
}

