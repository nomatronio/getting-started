job "agent-orchestrator" {
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
        NAME    = "agent-orchestrator"
        MESSAGE = "agent-orchestrator response"
      }

      resources {
        cpu    = 1
        memory = 10
      }
    }
  }
}
