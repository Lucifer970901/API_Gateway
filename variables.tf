// Copyright (c) 2021, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "fingerprint" {
  description = "fingerprint of oci api key"
  type        = string
}

variable "key_file_path" {
  description = "path to oci api private key used"
  type        = string
}

variable "region" {
  description = "the oci region where resources will be created"
  type        = string
}

variable "tenancy_id" {
  description = "tenancy id where to create the sources"
  type        = string
}

variable "user_id" {
  description = "id of user that terraform will use to create the resources"
  type        = string
}

variable "compartment_ids" {
  type = map(string)
}

variable "subnet_ids" {
  type = map(string)
}

variable "function_ids" {
  type = map(string)
}

variable "apigw_params" {
  type = map(object({
    compartment_name = string
    subnet_name      = string
    display_name     = string
    endpoint_type    = string
  }))
}

variable "gwdeploy_params" {
  description = "API Gateway Deployment Params"
  type = map(object({
    compartment_name = string
    gateway_name     = string
    display_name     = string
    path_prefix      = string
    access_log       = bool
    exec_log_lvl     = string
    function_routes = list(object({
      type          = string
      path          = string
      methods       = list(string)
      function_name = string
    }))
    http_routes = list(object({
      type            = string
      path            = string
      methods         = list(string)
      url             = string
      connect_timeout = number
      ssl_verify      = bool
      read_timeout    = number
      send_timeout    = number
    }))
    stock_routes = list(object({
      type    = string
      path    = string
      methods = list(string)
      status  = number
      body    = string
      headers = list(object({
        name  = string
        value = string
      }))
    }))
  }))
}
