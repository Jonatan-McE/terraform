provider "rancher2" {
  version   = "1.8.3"
  api_url   = "https://${var.management_api.url.value}"
  token_key = var.management_api_token
  insecure  = true
}