
kubernetes_version = "v1.18.6-rancher1-1"

vsphere_settings = {
  server_url = ""
  datacenter = ""
  cluster    = ""
  datastore  = ""
  network    = ""
  template   = ""
}

vsphere_credentials = {
  terraform_username  = ""
  terraform_password  = ""
  kubernetes_username = ""
  kubernetes_password = ""
}


management_api = {
  url              = { 
    value = "api.k8s.example.com"
  }
  default-password = {
    value = "admin"
  }
  certificates = {
    cert = <<-EOT
          -----BEGIN CERTIFICATE-----
          
          -----END CERTIFICATE-----
          EOT
    key  = <<-EOT
          -----BEGIN PRIVATE KEY-----
          
          -----END PRIVATE KEY-----
          EOT
    ca   = <<-EOT
          -----BEGIN CERTIFICATE-----
          
          -----END CERTIFICATE-----
          EOT
  }
  okta = {
    metadata = <<-EOT
          ...
          EOT
  }
}

argocd_settings = {
  namespace                 = "argocd-system"
  git_username              = ""
  git_password              = ""
  git_repository            = "https://github.com/example/argocd.git"
  git_path                  = "clusters/management"
}

// Management cluster settings
cluster_settings_management = {
  nodes = {
    k8s-mgmt-cont-01 = {
      address   = "10.0.0.211"
      netmask   = "24"
      gateway   = "10.0.0.254"
      dns       = ["10.0.0.10", "10.0.0.11"]
      num_cpu   = 2
      mem       = 6144
      disk_size = 16
      role      = ["controlplane", "worker", "etcd"]
    }
    k8s-mgmt-cont-02 = {
      address   = "10.0.0.212"
      netmask   = "24"
      gateway   = "10.0.0.254"
      dns       = ["10.0.0.10", "10.0.0.11"]
      num_cpu   = 2
      mem       = 6144
      disk_size = 16
      role      = ["controlplane", "worker", "etcd"]
    }
    k8s-mgmt-cont-03 = {
      address   = "10.0.0.213"
      netmask   = "24"
      gateway   = "10.0.0.254"
      dns       = ["10.0.0.10", "10.0.0.11"]
      num_cpu   = 2
      mem       = 6144
      disk_size = 16
      role      = ["controlplane", "worker", "etcd"]
    }
  }
}


// Private cluster settings
cluster_settings_private = {
  nodes = {
    k8s-private-cont-01 = {
      address   = "10.0.0.221"
      netmask   = "24"
      gateway   = "10.0.0.254"
      dns       = ["10.0.0.10", "10.0.0.11"]
      num_cpu   = 2
      mem       = 4096
      disk_size = 16
      role      = ["controlplane", "worker", "etcd"]
    }
    k8s-private-cont-02 = {
      address   = "10.0.0.222"
      netmask   = "24"
      gateway   = "10.0.0.254"
      dns       = ["10.0.0.10", "10.0.0.11"]
      num_cpu   = 2
      mem       = 4096
      disk_size = 16
      role      = ["controlplane", "worker", "etcd"]
    }
    k8s-private-cont-03 = {
      address   = "10.0.0.223"
      netmask   = "24"
      gateway   = "10.0.0.254"
      dns       = ["10.0.0.10", "10.0.0.11"]
      num_cpu   = 2
      mem       = 4096
      disk_size = 16
      role      = ["controlplane", "worker", "etcd"]
    }
    k8s-private-work-01 = {
      address   = "10.0.0.224"
      netmask   = "24"
      gateway   = "10.0.0.254"
      dns       = ["10.0.0.10", "10.0.0.11"]
      num_cpu   = 2
      mem       = 4096
      disk_size = 24
      role      = ["worker"]
    }
  }
}




// Public cluster settings
cluster_settings_public = {
  nodes = {
    k8s-public-cont-01 = {
      address   = "10.0.0.231"
      netmask   = "24"
      gateway   = "10.0.0.254"
      dns       = ["10.0.0.10", "10.0.0.11"]
      num_cpu   = 2
      mem       = 4096
      disk_size = 16
      role      = ["controlplane", "worker", "etcd"]
    }
    k8s-public-cont-02 = {
      address   = "10.40.0.232"
      netmask   = "24"
      gateway   = "10.0.0.254"
      dns       = ["10.0.0.10", "10.0.0.11"]
      num_cpu   = 2
      mem       = 4096
      disk_size = 16
      role      = ["controlplane", "worker", "etcd"]
    }
    k8s-public-cont-03 = {
      address   = "10.40.0.233"
      netmask   = "24"
      gateway   = "10.0.0.254"
      dns       = ["10.0.0.10", "10.0.0.11"]
      num_cpu   = 2
      mem       = 4096
      disk_size = 16
      role      = ["controlplane", "worker", "etcd"]
    }
    k8s-public-work-01 = {
      address   = "10.40.0.234"
      netmask   = "24"
      gateway   = "10.0.0.254"
      dns       = ["10.0.0.10", "10.0.0.11"]
      num_cpu   = 2
      mem       = 4096
      disk_size = 16
      role      = ["worker"]
    }
  }
}