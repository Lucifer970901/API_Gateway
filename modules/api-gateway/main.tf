// Copyright (c) 2021, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.


data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_ids[var.apigw_params[keys(var.apigw_params)[0]].compartment_name]
}

resource "oci_apigateway_gateway" "this" {
  for_each       = var.apigw_params
  compartment_id = var.compartment_ids[each.value.compartment_name]
  endpoint_type  = each.value.endpoint_type
  subnet_id      = var.subnet_ids[each.value.subnet_name]
  display_name   = each.value.display_name
}

data "oci_apigateway_gateways" "existing" {
  for_each       = var.apigw_params
  compartment_id = var.compartment_ids[each.value.compartment_name]
}

data "local_file" "api_description_file" {
    filename = "./data/openapi.yaml"
    #filename =  "../../data/openapi.yaml"
}

locals {
    api_description = yamldecode(data.local_file.api_description_file.content)
}


resource "oci_apigateway_api" "this" {
    for_each = fileset("${path.module}../../data/openapi.yaml", "*.yaml")
    compartment_id = var.compartment_ids[each.value.compartment_name]
    #content = file("${path.module}/openapi/${each.value}")
    #display_name = yamldecode(file("${path.module}/openapi/${each.value}")).info.title  
    #compartment_id = var.compartment_id
    content =  data.local_file.api_description_file.content
    display_name = local.api_description.info.title
}
  locals {
  backend_types = {
    function       = "ORACLE_FUNCTIONS_BACKEND"
    http           = "HTTP_BACKEND"
    stock_response = "STOCK_RESPONSE_BACKEND"
  }
}

resource "oci_apigateway_deployment" "this" {
  for_each       = var.gwdeploy_params
  compartment_id = var.compartment_ids[each.value.compartment_name]
  path_prefix    = each.value.local.api_description.basePath
  gateway_id     = oci_apigateway_gateway.this[each.value.gateway_name].id
  display_name   = each.value.local.api_description.info.title

  specification {

    logging_policies {
      access_log {
        is_enabled = each.value.access_log
      }

      execution_log {
        is_enabled = each.value.exec_log_lvl != null ? true : false
        log_level  = each.value.exec_log_lvl != null ? each.value.exec_log_lvl : null
      }
    }

    dynamic "routes" {
      iterator = routes
      for_each = (lookup(each.value, "function_routes", null) != null) ? each.value.function_routes : []

      content {
        methods = routes.value.methods
        path    = routes.value.path
        backend {
          type        = local.backend_types[routes.value.type]
          function_id = var.function_ids[routes.value.function_name]
        }
      }
    }

    dynamic "routes" {
      iterator = routes
      for_each = (lookup(each.value, "http_routes", null) != null) ? each.value.http_routes : []

      content {
        methods = routes.value.methods
        path    = routes.value.path

        backend {
          type                       = local.backend_types[routes.value.type]
          url                        = routes.value.url
          is_ssl_verify_disabled     = routes.value.ssl_verify
          connect_timeout_in_seconds = routes.value.connect_timeout
          read_timeout_in_seconds    = routes.value.read_timeout
          send_timeout_in_seconds    = routes.value.send_timeout
        }
      }
    }

    dynamic "routes" {
      iterator = routes
      for_each = (lookup(each.value, "stock_routes", null) != null) ? each.value.stock_routes : []

      content {
        methods = routes.value.methods
        path    = routes.value.path

        backend {
          type   = local.backend_types[routes.value.type]
          status = routes.value.status
          body   = routes.value.body
          dynamic "headers" {
            iterator = headers
            for_each = routes.value.type == "stock_response" ? routes.value.headers : []
            content {
              name  = headers.value.name
              value = headers.value.value
            }
          }
        }
      }
    }

  }
}

data "oci_apigateway_deployments" "existing" {
  for_each       = var.gwdeploy_params
  compartment_id = var.compartment_ids[each.value.compartment_name]
}

