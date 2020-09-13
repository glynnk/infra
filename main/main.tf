# main.tf

# Remote state - so no matter where we check this project out we can sync with the current state
terraform {
  backend "s3" {
    endpoint = "ams3.digitaloceanspaces.com"
    region   = "eu-west-1"           # not used since it's a DigitalOcean spaces bucket
    key      = "main.tfstate"
    bucket   = "glynnk"

    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}

# main infra (corss-environment infra)
module "base" {
  source = "github.com/glynnk/infra-modules//root?ref=1.1.0"
  root   = {
    name    = "base"
    domain  = "glynnk.com"
  }
}

