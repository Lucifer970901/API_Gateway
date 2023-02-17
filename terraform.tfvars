// Copyright (c) 2021, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

 

compartment_ids = {
  #Generic = "ocid1.compartment.oc1..aaaaaaaapczie5rrj3l223ecojhyfu4bp4xak6bjax7xv5xdhjaakpqpiwca" # Compartment OCID
   Generic = "ocid1.compartment.oc1..aaaaaaaaukottugsmj5vmneywbzvecjbg5pew2b7clgnm53zwyvgdutdiwvq"
}

subnet_ids = {
  #public_subnet_vcn  = "ocid1.subnet.oc1.iad.aaaaaaaac522bge57owy32kenre62cthk4o35miguybhjzulcqbirxoc7z2q" # Put OCID for 1 subnet
  public_subnet_vcn = "ocid1.subnet.oc1.iad.aaaaaaaaxi67xath5e6e57ffg5ilwbqoxdaiicgu7zorpcwz6bozi2bb6haa"
}

function_ids = {
  helloworld-func = "" # Try enter null value instead of OCID
}

apigw_params = {
  apigw = {
    compartment_name = "Generic"
    endpoint_type    = "PUBLIC"
    subnet_name      = "public_subnet_vcn"
    display_name     = "test_apigw"
  }
}


gwdeploy_params = {
  api_deploy1 = {
    compartment_name = "Generic" # Check accordingly while connecting to backend API call [GET/POST]
    gateway_name     = "apigw"
    display_name     = "tf_deploy"
    path_prefix      = "/tf"
    access_log       = true
    exec_log_lvl     = "WARN"

    function_routes = [
      /*{
        type          = "function"
        path          = "/func"
        methods       = ["GET", ]
        function_name = "helloworld-func"
      },*/
    ]
    http_routes = [
      /*{
        type            = "http"
        path            = "/http"
        methods         = ["GET", ]
        url             = "http://152.67.128.232/"
        ssl_verify      = true
        connect_timeout = 60
        read_timeout    = 40
        send_timeout    = 10
      },*/
    ]
    stock_routes = [
      { 
        methods = ["GET", ]
        path    = "/stock"
        type    = "stock_response"
        status  = 200
        body    = "The API GW deployment was successful."
        headers = [
          {
            name  = "Content-Type"
            value = "text/plain"
          },
        ]

      },
    ]

  }
}
