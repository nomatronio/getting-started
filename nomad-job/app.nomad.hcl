variable "image_tag" {
  type        = string
  description = "Docker image to deploy."
  default     = "nginx:1.27-alpine"
}

variable "port" {
  type        = number
  description = "Port to expose for the service."
  default     = 8080
}

job "getting-started-app" {
  datacenters = ["dc1"]
  type        = "service"

  group "app" {
    count = 1

    network {
      port "http" {
        static = var.port
        to     = 80
      }
    }

    task "app" {
      driver = "docker"

      config {
        image = var.image_tag
        ports = ["http"]
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
