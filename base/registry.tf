# main.tf
# Create the container registry
resource "digitalocean_container_registry" "glynnk" {
  name = "glynnk"
}

