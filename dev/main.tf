# main.tfvars

variable "do_access_token" {}

# provision the dev environment
module "dev" {
  source      = "github.com/glynnk/infra-modules//environment?ref=1.1.0"
  environment = {
    name    = "dev"
    region  = "ams3"
    domain  = "glynnk.com"
    token   = var.do_access_token
    cluster = {
      default_node_pool_size = 2      
      app_node_pool_size_min = 1      
      app_node_pool_size_max = 5      
      auto_upgrade           = true   
      kubernetes_version     = "1.18.8-do.0"
    }
  }
}

