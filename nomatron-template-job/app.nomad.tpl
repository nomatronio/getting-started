job "getting-started-template-app" {
  datacenters = ["dc1"]
  type        = "service"

  group "app" {
    count = 1

    network {
      port "http" {
        static = NOMATRON_VAR_app_port
        to     = 80
      }
    }

    task "app" {
      driver = "docker"

      config {
        image = "${ NOMATRON_VAR_app_image }"
        ports = ["http"]
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
