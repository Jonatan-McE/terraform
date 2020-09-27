terraform {
  backend "s3" {
    region                      = "main"
    bucket                      = "terraform"
    key                         = "state/kubernetes/terraform.tfstate"
    endpoint                    = "https://freenas.example.com:9000"
    force_path_style            = true
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}