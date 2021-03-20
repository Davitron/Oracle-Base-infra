resource "oci_identity_compartment" "test" {
  name = "bpc-infra-test"
  description = "Compartment for the test environment"
}


data "oci_identity_availability_domain" "ad"{
    compartment_id = oci_identity_compartment.test.compartment_id
    ad_number = 1
}

resource "oci_core_vcn" "test_network" {
  cidr_block = var.vcn_cidr_block
  compartment_id = oci_identity_compartment.test.compartment_id
  display_name = "TestVCN"
  dns_label = "tftestvcn"
}


resource "oci_core_subnet" "test_public_subnet" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  cidr_block = var.public_subnet_cidr
  display_name = "Test-Public-SUbnet"
  dns_label = "tftestpublicsubnet"

  compartment_id = oci_identity_compartment.test.compartment_id
  vcn_id = oci_core_vcn.test_network.id
}

resource "oci_core_internet_gateway" "test_internet_gateway" {
    compartment_id = oci_identity_compartment.test.compartment_id
    vcn_id = oci_core_vcn.test_network.id
    display_name = "TestInternetGatway"
}

resource "oci_core_route_table" "public_rt" {
  compartment_id = oci_identity_compartment.test.compartment_id
  vcn_id = oci_core_vcn.test_network.id
  display_name = "public-route-table"

  route_rules {
    destination = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.test_internet_gateway.id
  }
}

resource "oci_core_route_table_attachment" "public_rt_attachment" {
  subnet_id = oci_core_subnet.test_public_subnet.id
  route_table_id = oci_core_route_table.public_rt.id
}

resource "oci_core_security_list" "test_security_list" {
  compartment_id  = oci_identity_compartment.test.compartment_id
  vcn_id = oci_core_vcn.test_network.id

  display_name = "test-SL"

  egress_security_rules {
    destination  = "0.0.0.0/0"
    protocol     = "all"
  }

  ingress_security_rules {
    description = "Allow inbound SSH traffic"
    protocol    = 6
    source      = "0.0.0.0/0"

    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    description = "Allow inbound HTTPS traffic"
    protocol    = 6
    source      = "0.0.0.0/0"

    tcp_options {
      min = 443
      max = 443
    }
  }

  ingress_security_rules {
    description = "Allow inbound HTTP traffic"
    protocol    = 6
    source      = "0.0.0.0/0"

    tcp_options {
      min = 80
      max = 80
    }
  }

  ingress_security_rules {
    protocol = 1
    source   = "0.0.0.0/0"

    icmp_options {
      code = 4
      type = 3
    }
  }


  # allow all internal traffic in private subnet
  ingress_security_rules {
    description = "Allow all traffic in private subnet"
    protocol    = "all"
    source      = var.vcn_cidr_block
  }

  # allow all internal traffic in private subnet
  ingress_security_rules {
    description = "Allow all traffic in private subnet"
    protocol    = "all"
    source      = var.private_subnet_cidr
  }

  # Allow ICMP traffic locally
  ingress_security_rules {
    description = "Allow ICMP traffic locally not sure"
    protocol    = 1
    source      = var.vcn_cidr_block
  }
}


resource "oci_core_dhcp_options" "test_dhcp_options" {
    #Required
    compartment_id = oci_identity_compartment.test.compartment_id
    options {
        type = "DomainNameServer"
        server_type = "VcnLocalPlusInternet"
    }

    # options {
    #     type = "SearchDomain"
    #     search_domain_names = [ "test.com" ]
    # }

    vcn_id = oci_core_vcn.test_network.id

    #Optional
    display_name = "Test-DHCP"
}
