# main.tf
# Deploy the actual Kubernetes cluster

data "digitalocean_kubernetes_versions" "kube_version" {
  version_prefix = "1." # wer're always getting the latest
}

resource "digitalocean_kubernetes_cluster" "home" {
  name    = "home"
  region  = "ams3"
  auto_upgrade = true  # with automatic updates since this is not a production environment
  version = data.digitalocean_kubernetes_versions.kube_version.latest_version
  vpc_uuid = digitalocean_vpc.home.id

  tags = ["infra-home"]

  # This default node pool is mandatory
  node_pool {
    name       = "default-pool"
    size       = "s-1vcpu-2gb"
    auto_scale = false
    node_count = 2
    tags       = [
      "infra-home",
      "home-default-pool",
      "home-kube-node",
      "kube-node"
    ]

    labels = {
      service  = "default"
      priority = "high"
    }
  }
}

# Another node pool for applications
resource "digitalocean_kubernetes_node_pool" "home_node_pool" {
  cluster_id = digitalocean_kubernetes_cluster.home.id
  name = "home-node-pool"
  size = "s-2vcpu-2gb"

  tags = [
    "infra-home",
    "home-app-pool",
    "home-kube-node",
    "kube-node"
  ]

  # autoscaling
  auto_scale = true
  min_nodes  = 1
  max_nodes  = 5

  labels = {
    service  = "apps"
    priority = "high"
  }
}

provider "kubernetes" {
  version = "~> 1.12.0"
  host  = digitalocean_kubernetes_cluster.home.endpoint
  token = digitalocean_kubernetes_cluster.home.kube_config[0].token
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.home.kube_config[0].cluster_ca_certificate
  )
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"
  }
}

resource "kubernetes_namespace" "ci" {
  metadata {
    name = "ci"
  }
}

provider "helm" {
  version = "~> 1.2.4"
  kubernetes {
    host  = digitalocean_kubernetes_cluster.home.endpoint
    token = digitalocean_kubernetes_cluster.home.kube_config[0].token
    cluster_ca_certificate = base64decode(
      digitalocean_kubernetes_cluster.home.kube_config[0].cluster_ca_certificate
    )
  }
}

resource "helm_release" "ingress_nginx" {
  repository = "https://kubernetes.github.io/ingress-nginx"
  name       = "ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = kubernetes_namespace.ingress_nginx.metadata[0].name

  set {
    name  = "controller.publishService.enabled"
    value = "true"
  }
}

resource "helm_release" "prometheus_operator" {
  repository = "https://kubernetes-charts.storage.googleapis.com"
  name       = "prometheus-operator"
  chart      = "prometheus-operator"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
}

resource "kubernetes_ingress" "grafana" {
  metadata {
    name       = "grafana"
    namespace  = kubernetes_namespace.monitoring.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rule {
      host = "grafana.home.glynnk.com"
      http {
        path {
          backend {
            service_name = "prometheus-operator-grafana"
            service_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress" "prometheus" {
  metadata {
    name       = "prometheus"
    namespace  = kubernetes_namespace.monitoring.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rule {
      host = "prometheus.home.glynnk.com"
      http {
        path {
          backend {
            service_name = "prometheus-operator-prometheus"
            service_port = 9090
          }
        }
      }
    }
  }
}
