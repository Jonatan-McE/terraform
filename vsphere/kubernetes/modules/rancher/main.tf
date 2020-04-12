# --- Create Rancher (managment) instnace ---
data "helm_repository" "rancher" {
  name = "stable"
  url  = "https://releases.rancher.com/server-charts/stable"
}

resource "kubernetes_namespace" "cattle-system" {
  count = var.management_cluster ? 1 : 0
  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
  metadata {
    name = "cattle-system"
  } 
}

resource "kubernetes_secret" "ingress-secrets" {
  count = var.management_cluster ? 1 : 0
  lifecycle {
    ignore_changes = [
      metadata[0].annotations
    ]
  }
  metadata {
    name = "tls-rancher-ingress"
    namespace = "cattle-system"
  }
  data = {
    "tls.crt" = var.management_cluster_certs.cert
    "tls.key" = var.management_cluster_certs.key
  }
  type = "kubernetes.io/tls"
}

resource "kubernetes_secret" "ca-secrets" {
  count = var.management_cluster ? 1 : 0
  lifecycle {
    ignore_changes = [
      metadata[0].annotations
    ]
  }
  metadata {
    name = "tls-ca"
    namespace = "cattle-system"
  }  
  data = {
    "cacerts.pem" = var.management_cluster_certs.ca
  }
}  

resource "helm_release" "rancher" {
  count = var.management_cluster ? 1 : 0
  name       = "rancher"
  repository = data.helm_repository.rancher.metadata[0].name
  chart      = "rancher"
  namespace = "cattle-system"
  set {
    name  = "hostname"
    value =  var.management_cluster_url
  }
  set {
    name  = "ingress.tls.source"
    value = "secret"
  }
  set {
      name = "privateCA"
      value = true
  }
}

resource "rancher2_bootstrap" "bootstrap" {
  depends_on = [helm_release.rancher[0]]
  count      = var.management_cluster ? 1 : 0
  password  = var.management_cluster_admin_password
  telemetry = false
}

resource "local_file" "rancher_api_key" {
  count      = var.management_cluster ? 1 : 0
  filename = "./.apikeys/apikey_${var.cluster_name}"
  sensitive_content  = rancher2_bootstrap.bootstrap[0].token
}


# --- Join RKE cluster to Rancher (managment) instnace --- 

resource "rancher2_cluster" "cluster_onboarding" {
  count       = var.management_cluster ? 0 : 1
  lifecycle {
    ignore_changes = [
      annotations
    ]
  }
  provider    = rancher2.admin
  name        = var.cluster_name
  description = var.cluster_name
  annotations = {
    "capabilities/pspEnabled" = "true"
  }
}

data "http" "onboarding_yaml" {
  depends_on = [rancher2_cluster.cluster_onboarding[0]]
  count      = var.management_cluster ? 0 : 1
  url        = rancher2_cluster.cluster_onboarding[0].cluster_registration_token[0].manifest_url
}

resource "local_file" "kube_cluster_yaml" {
  depends_on = [data.http.onboarding_yaml]
  count      = var.management_cluster ? 0 : 1
  filename   = ".kube/kubeconfig_${var.cluster_name}_onboarding.yml"
  content    = data.http.onboarding_yaml[0].body
}

resource "null_resource" "cluster_onboarding" {
  depends_on = [rancher2_cluster.cluster_onboarding[0], data.http.onboarding_yaml[0]]
  count      = var.management_cluster ? 0 : 1
  provisioner "local-exec" {
    command = "kubectl --kubeconfig ${var.kubeconfig_filename} --insecure-skip-tls-verify apply -f .kube/kubeconfig_${var.cluster_name}_onboarding.yml"
  }
}