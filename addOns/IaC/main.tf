resource "kubernetes_service_account" "grafana_alloy" {
  metadata {
    name      = "grafana-alloy"
    namespace = "monitoring"
  }
}

resource "kubernetes_cluster_role" "grafana_alloy" {
  metadata {
    name = "grafana-alloy"
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["nodes", "nodes/proxy", "nodes/metrics", "services", "endpoints", "pods", "events", "ingresses", "configmaps"]
  }

  rule {
    verbs             = ["get", "list", "watch"]
    non_resource_urls = ["/metrics"]
  }
}

resource "kubernetes_cluster_role_binding" "grafana_alloy" {
  metadata {
    name = "grafana-alloy"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "grafana-alloy"
    namespace = "monitoring"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "grafana-alloy"
  }
}

resource "kubernetes_service" "grafana_alloy" {
  metadata {
    name      = "grafana-alloy"
    namespace = "monitoring"

    labels = {
      name = "grafana-alloy"
    }
  }

  spec {
    port {
      name        = "grafana-alloy-http-metrics"
      port        = 80
      target_port = "80"
    }

    selector = {
      name = "grafana-alloy"
    }

    cluster_ip = "None"
  }
}

resource "kubernetes_service" "lb_grafana_alloy" {
  metadata {
    name      = "lb-grafana-alloy"
    namespace = "monitoring"

    labels = {
      app = "grafana-alloy"
    }
  }

  spec {
    port {
      name        = "grafana-alloy-otlp-cgrp"
      port        = 4317
      target_port = "4317"
    }

    port {
      name        = "grafana-alloy-otlp-http"
      port        = 4318
      target_port = "4318"
    }

    port {
      name        = "grafana-agent-otlp-otr"
      port        = 9464
      target_port = "9464"
    }

    selector = {
      name = "grafana-alloy"
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_stateful_set" "grafana_alloy" {
  metadata {
    name      = "grafana-alloy"
    namespace = "monitoring"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        name = "grafana-alloy"
      }
    }

    template {
      metadata {
        labels = {
          name = "grafana-alloy"
        }
      }

      spec {
        volume {
          name = "grafana-alloy"

          config_map {
            name = "grafana-alloy"
          }
        }

        container {
          name  = "grafana-alloy"
          image = "grafana/alloy:latest"
          args  = ["run", "/etc/agent/config.alloy", "--storage.path=/var/lib/alloy/data", "--server.http.listen-addr=0.0.0.0:12345"]

          port {
            name           = "http-metrics"
            container_port = 80
          }

          port {
            container_port = 4317
          }

          port {
            container_port = 4318
          }

          port {
            container_port = 9464
          }

          env {
            name = "HOSTNAME"

            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }

          volume_mount {
            name       = "grafana-alloy"
            mount_path = "/etc/agent/config.alloy"
          }

          image_pull_policy = "IfNotPresent"
        }

        service_account_name = "grafana-alloy"
      }
    }

    volume_claim_template {
      metadata {
        name      = "agent-wal"
        namespace = "monitoring"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "5Gi"
          }
        }
      }
    }

    service_name = "grafana-alloy"

    update_strategy {
      type = "RollingUpdate"
    }
  }
}

resource "kubernetes_persistent_volume_claim" "grafana_alloy_claim_0" {
  metadata {
    name = "grafana-alloy-claim0"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "100Mi"
      }
    }
  }
}