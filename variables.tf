variable "tenancy_ocid" {
  type = string
}

variable "user_ocid" {
  type = string
}

variable "fingerprint" {
  type  = string
}

variable "private_key" {
  type  = string
}

variable "region" {
  default = "eu-frankfurt-1"
}

# variable "compartment_name" {
#   default = "test"
# }

variable "vcn_cidr_block" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.0.0/17"
}

variable "private_subnet_cidr" {
  default = "10.0.128.0/17"
}