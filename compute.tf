resource "oci_core_instance" "mongo" {
  availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.AD - 1], "name")
  compartment_id      = var.compartment_ocid
  display_name        = "${var.name}-mongo"
  shape               = var.instance_shape

  create_vnic_details {
    display_name = "${var.name}-mongo-subnet"
    subnet_id    = oci_core_subnet.subnet.id
  }

  shape_config {
    memory_in_gbs = 8
    ocpus         = 2
  }

  source_details {
    source_type = "image"
    source_id   = lookup(data.oci_core_images.compute_images.images[0], "id")
  }

  metadata = {
    ssh_authorized_keys = chomp(file(var.ssh_public_key))
  }
}
