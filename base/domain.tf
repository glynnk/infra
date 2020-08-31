# main.tf
# Provision the domain and records

resource "digitalocean_domain" "glynnk_domain" {
  name       = "glynnk.com"
}


