project = "linky"

app "linky" {
  labels = {
    "service" = "linky",
    "env"     = "dev"
  }

  config {
    env = {
      DATABASE_URL=var.database_url
    }
  }

  build {
    use "pack" {}
    registry {
      use "docker" {
        image = "catsby.jfrog.io/linky-demo-docker/linky"
        tag   = "latest"

        username = var.registry_username
        password = var.registry_password
        local = false
      }
    }
  }

  deploy {
    use "kubernetes" {
      probe_path = "/"
      image_secret = var.regcred_secret
    }
  }

  release {
    use "kubernetes" {
      // Sets up a load balancer to access released application
      load_balancer = true
      port          = 3000
    }
  }
}

runner {
  enabled = true

  data_source "git" {
    url  = "https://github.com/catsby/My-Link-Manager.git"
    ref = "refs/heads/dev"
  }
}

variable "regcred_secret" {
  default     = "regcred"
  type        = string
  description = "The existing secret name inside Kubernetes for authenticating to the container registry"
}

variable "registry_username" {
  default = dynamic("kubernetes", {
    name = "registry-userpass"
    key  = "username"
    secret = true
  })
  type        = string
  sensitive   = true
  description = "username for container registry"
}

variable "registry_password" {
  default = dynamic("kubernetes", {
    name = "registry-userpass"
    key  = "password"
    secret = true
  })
  type        = string
  sensitive   = true
  description = "password for registry" // DO NOT COMMIT YOUR PASSWORD TO GIT
}

variable "database_url" {
  default = dynamic("kubernetes", {
    name = "db-url"
    key  = "dburl"
    secret = true
  })
  type        = string
  sensitive   = true
  description = "db url to connect"
}
