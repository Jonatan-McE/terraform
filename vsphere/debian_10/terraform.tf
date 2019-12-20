provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = "true"
  version              = "1.13.0"
}

data "vsphere_datacenter" "dc" {
  name = var.datacenter
}
data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_network" "network" {
  name          = var.network
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_virtual_machine" "template" {
  name          = var.template
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  count            = var.num_of_vms
  name             = format("%s-%s", var.vm_name, count.index + 1)
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  num_cpus         = var.num_cpus
  memory           = var.memory
  scsi_type        = data.vsphere_virtual_machine.template.scsi_type
  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }
  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    linked_clone = true
  }
  provisioner "remote-exec" {
    inline = [
      "sudo bash -c \"echo ${self.name} > /etc/hostname\"",
      "sudo hostname ${self.name}"
    ]
    connection {
      type     = "ssh"
      host     = self.default_ip_address
      user     = "automation"
      private_key = file("~/.ssh/id_rsa")
    }
  }
}

