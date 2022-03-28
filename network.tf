# Network
resource "oci_core_virtual_network" "network" {
  display_name   = "${var.name}-network"
  dns_label      = var.name
  cidr_block     = var.vcn_cidr
  compartment_id = var.compartment_ocid
}

# Internet Gateway
resource "oci_core_internet_gateway" "internet_gateway" {
  display_name   = "${var.name}-internet_gateway"
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.network.id
}

# Public Route Table
resource "oci_core_route_table" "route_table" {
  display_name   = "${var.name}-route_table"
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.network.id

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
  }
}

# Subnet
resource "oci_core_subnet" "subnet" {
  availability_domain = ""
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_virtual_network.network.id
  cidr_block          = cidrsubnet(var.vcn_cidr, 8, 1)
  display_name        = "${var.name}-subnet"
  dns_label           = "${var.name}-subnet"
  route_table_id      = oci_core_route_table.route_table.id
  security_list_ids   = [oci_core_security_list.security_list.id]
}

# Security List
resource "oci_core_security_list" "security_list" {
  display_name   = "${var.name}-security_list"
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.network.id

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 80
      max = 80
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 443
      max = 443
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 27017
      max = 27017
    }
  }
}
