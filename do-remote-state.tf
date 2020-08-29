# main.tf
# Remote state
terraform {
  backend "s3" {
    endpoint                    = "ams3.digitaloceanspaces.com/" # specify the correct DO region
    region                      = "us-west-1" # not used since it's a DigitalOcean spaces bucket
    key                         = "terraform.tfstate"
    bucket                      = "infra-state" # The name of your Spaces

    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}
