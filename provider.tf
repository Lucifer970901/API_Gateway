provider "oci" {
  version          = ">=3.11"
  tenancy_ocid     = var.tenancy_id
  user_ocid        = var.user_id
  fingerprint      = var.fingerprint
  private_key_path = var.key_file_path
  region           = var.region
}

