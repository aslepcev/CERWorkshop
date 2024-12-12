
data "akamai_property_rules_builder" "webshop_rule_default" {
  rules_v2024_10_21 {
    name      = "default"
    is_secure = true
    comments  = "The Default Rule template contains all the necessary and recommended behaviors. Rules are evaluated from top to bottom and the last matching rule wins."
    // Send traffic to web origin by default
    behavior {
      origin {
        cache_key_hostname            = "REQUEST_HOST_HEADER"
        compress                      = true
        enable_true_client_ip         = true
        forward_host_header           = "CUSTOM"
        custom_forward_host_header    = "web-origin.akmworkshop.eu"
        hostname                      = var.web_origin_hostname
        http_port                     = 80
        https_port                    = 443
        ip_version                    = "IPV4"
        min_tls_version               = "DYNAMIC"
        origin_certificate            = ""
        origin_sni                    = true
        origin_type                   = "CUSTOMER"
        ports                         = ""
        tls_version_title             = ""
        true_client_ip_client_setting = false
        true_client_ip_header         = "True-Client-IP"
        verification_mode             = "PLATFORM_SETTINGS"
      }
    }
    behavior {
      cp_code {
        value {
          id       = 1741661
          name     = "hackathon2024-webshop"
        }
      }
    }
    children = [
      data.akamai_property_rules_builder.webshop_rule_accelerate_delivery.json,
      data.akamai_property_rules_builder.webshop_rule_offload_origin.json,
      data.akamai_property_rules_builder.webshop_rule_allowed_methods.json,
      data.akamai_property_rules_builder.webshop_rule_product_comments.json,
      data.akamai_property_rules_builder.webshop_rule_product_debug.json,
      data.akamai_property_rules_builder.webshop_rule_api.json,
      data.akamai_property_rules_builder.webshop_rule_ai.json,
    ]
  }
}

/*
** Rules enabling EdgeWorkers on /products/... urls
*/
data "akamai_property_rules_builder" "webshop_rule_product_comments" {
  rules_v2024_10_21 {
    name                  = "Product Comments"
    criteria_must_satisfy = "all"
    criterion {
      path {
        match_case_sensitive = false
        match_operator       = "MATCHES_ONE_OF"
        normalize            = false
        values               = ["/products/?*", ]
      }
    }
    criterion {
      request_header {
        header_name         = "pristine"
        match_operator      = "DOES_NOT_EXIST"
        match_wildcard_name = false
      }
    }
    dynamic behavior {
      for_each = var.edgeworker_id != "" ? ["1"] : []
      content {
        edge_worker {
          create_edge_worker  = ""
          edge_worker_id      = var.edgeworker_id
          enabled             = true // <=== Set to true to enable EdgeWorkers
          m_pulse             = false
          m_pulse_information = ""
          resource_tier       = ""
        }
      }
    }
  }
}


/*
** Rules debugging /products/test without Origin
*/
data "akamai_property_rules_builder" "webshop_rule_product_debug" {
  rules_v2024_10_21 {
    name                  = "Product Debug"
    criteria_must_satisfy = "all"
    criterion {
      path {
        match_case_sensitive = false
        match_operator       = "MATCHES_ONE_OF"
        normalize            = false
        values               = ["/products/test", ]
      }
    }
    criterion {
      request_header {
        header_name         = "pristine"
        match_operator      = "EXISTS"
        match_wildcard_name = false
      }
    }
    behavior {
      construct_response {
        enabled        = true
        response_code  = 200
        body           = "<html><head><title>test</title></head><body><div>This is a test product</div></body></html>"
        force_eviction = false
        ignore_purge   = true
      }
    }
  }
}


/*
** Override Origin for API hostname
*/
data "akamai_property_rules_builder" "webshop_rule_api" {
  rules_v2024_10_21 {
    name                  = "API"
    criteria_must_satisfy = "all"
    criterion {
      hostname {
        match_operator = "IS_ONE_OF"
        values         = [var.api_hostname, ]
      }
    }
    behavior {
      origin {
        hostname                      = var.api_origin_hostname
        forward_host_header           = "CUSTOM"
        custom_forward_host_header    = "api-origin.akmworkshop.eu"
        cache_key_hostname            = "REQUEST_HOST_HEADER"
        origin_type                   = "CUSTOMER"
        compress                      = true
        enable_true_client_ip         = true
        http_port                     = 80
        https_port                    = 443
        ip_version                    = "IPV4"
        min_tls_version               = "DYNAMIC"
        origin_certificate            = ""
        origin_sni                    = true
        ports                         = ""
        tls_version_title             = ""
        true_client_ip_client_setting = false
        true_client_ip_header         = "True-Client-IP"
        verification_mode             = "PLATFORM_SETTINGS"
      }
    }
  }
}

/*
** Override Origin for AI path, requested from EdgeWorkers
*/
data "akamai_property_rules_builder" "webshop_rule_ai" {
  rules_v2024_10_21 {
    name                  = "API"
    criteria_must_satisfy = "all"
    criterion {
      path {
        match_operator       = "MATCHES_ONE_OF"
        values               = ["/v2/models/sentiment*", ]
        match_case_sensitive = true
        normalize            = true
      }
    }
    behavior {
      origin {
        cache_key_hostname            = "REQUEST_HOST_HEADER"
        compress                      = true
        enable_true_client_ip         = true
        forward_host_header           = "CUSTOM"
        custom_forward_host_header    = "ai-origin.akmworkshop.eu"
        hostname                      = var.ai_origin_hostname
        http_port                     = 80
        https_port                    = 443
        ip_version                    = "IPV4"
        min_tls_version               = "DYNAMIC"
        origin_certificate            = ""
        origin_sni                    = true
        origin_type                   = "CUSTOMER"
        ports                         = ""
        tls_version_title             = ""
        true_client_ip_client_setting = false
        true_client_ip_header         = "True-Client-IP"
        verification_mode             = "PLATFORM_SETTINGS"
      }
    }
  }
}



/*
** Default rules found in most configuration
** Not much interest for this workshop
*/

data "akamai_property_rules_builder" "webshop_rule_accelerate_delivery" {
  rules_v2024_10_21 {
    name                  = "Accelerate delivery"
    comments              = "Control the settings related to improving the performance of delivering objects to your users."
    criteria_must_satisfy = "all"
    children = [
      data.akamai_property_rules_builder.webshop_rule_origin_connectivity.json,
      data.akamai_property_rules_builder.webshop_rule_protocol_optimizations.json,
    ]
  }
}

data "akamai_property_rules_builder" "webshop_rule_offload_origin" {
  rules_v2024_10_21 {
    name                  = "Offload origin"
    comments              = "Control the settings related to caching content at the edge and in the browser. As a result, fewer requests go to your origin, fewer bytes leave your data centers, and your assets are closer to your users."
    criteria_must_satisfy = "all"
    behavior {
      caching {
        behavior                 = "CACHE_CONTROL"
        cache_control_directives = ""
        cacheability_settings    = ""
        default_ttl              = "0s"
        enhanced_rfc_support     = true
        expiration_settings      = ""
        honor_max_age            = true
        honor_must_revalidate    = true
        honor_no_cache           = true
        honor_no_store           = true
        honor_private            = true
        honor_proxy_revalidate   = true
        honor_s_maxage           = true
        must_revalidate          = false
        revalidation_settings    = ""
      }
    }
    behavior {
      tiered_distribution {
        enabled = true
      }
    }
    behavior {
      origin_ip_acl {
        enable = true
      }
    }
    behavior {
      cache_key_query_params {
        behavior = "INCLUDE_ALL_ALPHABETIZE_ORDER"
      }
    }
    behavior {
      downstream_cache {
        allow_behavior = "LESSER"
        behavior       = "ALLOW"
        send_headers   = "CACHE_CONTROL"
        send_private   = false
      }
    }
    behavior {
      modify_via_header {
        enabled             = true
        modification_option = "REMOVE_HEADER"
      }
    }
    children = [
      data.akamai_property_rules_builder.webshop_rule_html_pages.json,
      data.akamai_property_rules_builder.webshop_rule_uncacheable_objects.json,
    ]
  }
}

data "akamai_property_rules_builder" "webshop_rule_origin_connectivity" {
  rules_v2024_10_21 {
    name                  = "Origin connectivity"
    comments              = "Optimize the connection between edge and origin."
    criteria_must_satisfy = "all"
    behavior {
      dns_async_refresh {
        enabled = true
        timeout = "1h"
      }
    }
  }
}

data "akamai_property_rules_builder" "webshop_rule_protocol_optimizations" {
  rules_v2024_10_21 {
    name                  = "Protocol optimizations"
    comments              = "Serve your website using modern and fast protocols."
    criteria_must_satisfy = "all"
    behavior {
      enhanced_akamai_protocol {
        display = ""
      }
    }
    behavior {
      http3 {
        enable = true
      }
    }
    behavior {
      http2 {
        enabled = ""
      }
    }
    behavior {
      allow_transfer_encoding {
        enabled = true
      }
    }
    behavior {
      sure_route {
        enabled                = false
        sr_download_link_title = ""
      }
    }
  }
}

data "akamai_property_rules_builder" "webshop_rule_html_pages" {
  rules_v2024_10_21 {
    name                  = "HTML pages"
    comments              = "Override the default caching behavior for HTML pages cached on edge servers."
    criteria_must_satisfy = "all"
    criterion {
      file_extension {
        match_case_sensitive = false
        match_operator       = "IS_ONE_OF"
        values               = ["html", "htm", "php", "jsp", "aspx", "EMPTY_STRING", ]
      }
    }
    behavior {
      caching {
        behavior = "NO_STORE"
      }
    }
  }
}

data "akamai_property_rules_builder" "webshop_rule_uncacheable_objects" {
  rules_v2024_10_21 {
    name                  = "Uncacheable objects"
    comments              = "Configure the default client caching behavior for uncacheable content at the edge."
    criteria_must_satisfy = "all"
    criterion {
      cacheability {
        match_operator = "IS_NOT"
        value          = "CACHEABLE"
      }
    }
    behavior {
      downstream_cache {
        behavior = "TUNNEL_ORIGIN"
      }
    }
  }
}

data "akamai_property_rules_builder" "webshop_rule_allowed_methods" {
  rules_v2024_10_21 {
    name                  = "Allowed methods"
    comments              = "Allow the use of HTTP methods. Consider enabling additional methods under a path match for increased origin security."
    criteria_must_satisfy = "all"
    behavior {
      all_http_in_cache_hierarchy {
        enabled = true
      }
    }
    behavior {
      allow_post {
        allow_without_content_length = false
        enabled                      = true
      }
    }
    behavior {
      allow_options {
        enabled = true
      }
    }
    behavior {
      allow_put {
        enabled = false
      }
    }
    behavior {
      allow_delete {
        enabled = false
      }
    }
    behavior {
      allow_patch {
        enabled = false
      }
    }
  }
}
