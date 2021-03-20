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
  type  = string
}

# variable "compartment_name" {
#   default = "test"
# }

variable "vcn_cidr_block" {
  type  = string
}

variable "public_subnet_cidr" {
  type  = string
}

variable "private_subnet_cidr" {
  type  = string
}