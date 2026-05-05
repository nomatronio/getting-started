job "admin-console" {
  datacenters = ["dc1"]
  type        = "service"

  group "app" {
    count = 1

    network {
      port "http" {
        to = 9090
      }
    }

    task "app" {
      driver = "docker"

      config {
        image = "nicholasjackson/fake-service:vm-v0.26.2"
        ports = ["http"]
      }

      env {
        NAME    = "admin-console"
        MESSAGE = "admin-console response"
      }

      resources {
        cpu    = 1
        memory = 10
      }
    }
  }
}
