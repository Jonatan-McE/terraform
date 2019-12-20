# Variable set in credentials.tfvars
variable vsphere_user {
    default = "user"
}
variable vsphere_password {
    default = "password"
}
variable vsphere_server {
    default = "vsphere.local"
}

# Variables set in terraform.tfvars
variable datacenter {
    default = "Datacenter"
}
variable cluster {
    default ="Lab"
}
variable datastore {
    default = "VSAN-Datastore"
}
variable network {
    default = "Lab"
}
variable template {
    default = "TEMPLATE_DEBIAN10"
}
variable vm_name {
    default = "Debian"
}
variable num_cpus {
    default = 2
}
variable memory {
    default = 2048
}
variable num_of_vms {
    default = 3
}