provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key =    var.private_key
  private_key_password = "Password@123"
  region           = var.region
}

terraform {
  backend "remote" {
    hostname  = "app.terraform.io"
    organization = "Innovectives"

    workspaces {
      name = "Oracle-Base-infra-test"
    }
  }
}


module "network" {
  source    = "./modules/network"
  vcn_cidr_block = var.vcn_cidr_block
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
}