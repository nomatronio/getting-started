job "worker-fleet" {
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
        image = "nicholasjackson/fake-service:latest"
        ports = ["http"]
      }

      env {
        NAME    = "worker-fleet"
        MESSAGE = "worker-fleet response"
      }

      resources {
        cpu    = 25
        memory = 32
      }
    }
  }
}
