// Copyright (c) 2021, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.


module "api-gateway" {
  source          = "./modules/api-gateway"
  compartment_ids = var.compartment_ids
  subnet_ids      = var.subnet_ids
  function_ids    = var.function_ids
  apigw_params    = var.apigw_params
  gwdeploy_params = var.gwdeploy_params
}


