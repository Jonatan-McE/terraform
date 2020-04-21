data "vsphere_datacenter" "dc" {
  name = var.vsphere.datacenter
}
data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere.cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_datastore" "datastore" {
  name          = var.vsphere.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_network" "network" {
  name          = var.vsphere.network
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_virtual_machine" "template" {
  name          = var.vsphere.template
  datacenter_id = data.vsphere_datacenter.dc.id
}

/*
resource "vsphere_folder" "vm_folder" {
  path          = "Kubernetes-Lab/${var.cluster_name}"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}
*/

resource "vsphere_virtual_machine" "vm" {
  for_each         = var.cluster_settings.nodes
  name             = each.key
  num_cpus         = each.value.num_cpu
  memory           = each.value.mem
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  scsi_type        = data.vsphere_virtual_machine.template.scsi_type
  disk {
    label            = "disk0"
    size             = each.value.disk_size
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }
  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }
  extra_config = {
    "guestinfo.cloud-init.config.data" = base64encode(
      templatefile(
        "${path.module}/cloud-init.tmpl", {
          host    = each.key,
          address = each.value.address,
          netmask = each.value.netmask,
          gateway = each.value.gateway,
          dns1    = each.value.dns[0]
          dns2    = each.value.dns[1]
        }
      )
    )
    "guestinfo.cloud-init.data.encoding" = "base64"
  }
}

resource rke_cluster "cluster" {
  depends_on         = [vsphere_virtual_machine.vm]
  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version
  addon_job_timeout  = 300
  dynamic "nodes" {
    for_each = var.cluster_settings.nodes
    content {
      address = nodes.value.address
      role    = nodes.value.role
      user    = "rancher"
      ssh_key = file("~/.ssh/id_rsa")
    }
  }
  services {
    kube_api {
      service_cluster_ip_range = "172.16.0.0/18"
      pod_security_policy      = false
    }
    kube_controller {
      cluster_cidr             = "172.16.64.0/18"
      service_cluster_ip_range = "172.16.0.0/18"
    }
    kubelet {
      cluster_dns_server = "172.16.0.10"
    }
  }
  authorization {
    mode = "rbac"
  }
  network {
    plugin = "calico"
  }
  ingress {
    provider = "nginx"
  }
  upgrade_strategy {
    drain                        = false
    max_unavailable_controlplane = "1"
    max_unavailable_worker       = "10%"
  }
  cloud_provider {
    name = "vsphere"
    vsphere_cloud_provider {
      disk {}
      network {}
      global {
        insecure_flag = true
      }
      virtual_center {
        name        = var.vsphere.server_url
        user        = var.vsphere_credentials.kubernetes_username
        password    = var.vsphere_credentials.kubernetes_password
        datacenters = var.vsphere.datacenter
      }
      workspace {
        server            = var.vsphere.server_url
        folder            = "kubernetes_${lower(var.cluster_name)}"
        default_datastore = var.vsphere.datastore
        datacenter        = var.vsphere.datacenter
      }
    }
  }
}

resource "local_file" "kube_cluster_yaml" {
  filename = ".kube/kubeconfig_${var.cluster_name}.yml"
  content  = rke_cluster.cluster.kube_config_yaml
}


// Import non-managment cluster

resource "rancher2_cluster" "cluster_import" {
  count = var.management ? 0 : 1
  lifecycle {
    ignore_changes = [
      annotations
    ]
  }
  name        = lower(var.cluster_name)
  description = "${var.cluster_name}-Cluster"
  annotations = {
    "capabilities/pspEnabled" = "false"
  }
}

data "http" "cluster_import_manifest" {
  depends_on = [rancher2_cluster.cluster_import]
  count      = var.management ? 0 : 1
  url        = rancher2_cluster.cluster_import[0].cluster_registration_token[0].manifest_url
}

resource "local_file" "kube_cluster_import_yaml" {
  depends_on = [data.http.cluster_import_manifest]
  count      = var.management ? 0 : 1
  lifecycle {
    ignore_changes = [
      content
    ]
  }
  filename = ".kube/kubeconfig_${var.cluster_name}_cluster_import_manifest.yml"
  content  = data.http.cluster_import_manifest[0].body
}

resource "null_resource" "cluster_import" {
  depends_on = [rancher2_cluster.cluster_import, data.http.cluster_import_manifest]
  count      = var.management ? 0 : 1
  provisioner "local-exec" {
    command = "kubectl --kubeconfig ${abspath(local_file.kube_cluster_yaml.filename)} --insecure-skip-tls-verify apply -f ${abspath(local_file.kube_cluster_import_yaml[0].filename)} "
  }
}

resource "null_resource" "dependency_setter" {
  count = var.management ? 0 : 1
  depends_on = [
    null_resource.cluster_import,
  ]
}