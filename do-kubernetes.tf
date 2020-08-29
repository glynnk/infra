# main.tf
# Deploy the actual Kubernetes cluster
resource "digitalocean_kubernetes_cluster" "kubernetes_cluster" {
  name    = "terraform-do-cluster"
  region  = "ams3"
  version = "1.18.6-do.0"

  tags = ["home-infra"]

  # This default node pool is mandatory
  node_pool {
    name       = "default-pool"
    size       = "s-1vcpu-2gb" # minimum size, list available options with `doctl compute size list`
    auto_scale = false
    node_count = 2
    tags       = ["node-pool-tag"]
    labels = {
      service  = "default"
      priority = "high"
    }
  }

}

# Another node pool for applications
resource "digitalocean_kubernetes_node_pool" "app_node_pool" {
  cluster_id = digitalocean_kubernetes_cluster.kubernetes_cluster.id

  name = "app-pool"
  size = "s-2vcpu-2gb" # small instances
  tags = ["applications"]

  # you can setup autoscaling
  auto_scale = true
  min_nodes  = 2
  max_nodes  = 5
  labels = {
    service  = "apps"
    priority = "high"
  }
}
