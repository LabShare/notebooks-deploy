##############################
## Start Main Module
#

#service account for PODs, this service account is for Kubernetes, not Google
resource "kubernetes_service_account" "kg-sa" {
  metadata {
    name = "kg-sa"
  }

  secret {
    name = "${kubernetes_secret.kg-secret.metadata.0.name}"
  }
}

resource "kubernetes_secret" "kg-secret" {
  metadata {
    name = "kg-secret"
  }
}

resource "kubernetes_pod" "kernel-gateway" {
  metadata {
    name = "kernel-gateway"

    labels {
      app = "kernel-gateway"
    }
  }

  spec {
    service_account_name = "${kubernetes_service_account.kg-sa.metadata.0.name}"

    container {
      image = ""
      name = "kg"

      port {
        container_port = 8888
      }

    #  volume_mount {
    #    mount_path = "/srv/kernel-gateway/kg/"
    #    name       = "gateway"
    #  }
    }

    #volume {
    #  name = "gateway"
    #}
  }
}

resource "kubernetes_service" "kernel-gateway" {
  metadata {
    name = "kernel-gateway"
  }

  spec {
    selector {
      app = "${kubernetes_pod.kernel-gateway.metadata.0.labels.app}"
    }

    port {
      port = "8888"
    }
  }
}
