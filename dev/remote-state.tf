# main.tf

# Remote state - so no matter where we check this project out we can sync with the current state
terraform {
  backend "s3" {
    endpoint = "ams3.digitaloceanspaces.com"
    region   = "eu-west-1"           # not used since it's a DigitalOcean spaces bucket
    bucket   = "glynnk"
    key      = "dev.tfstate"

    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}

