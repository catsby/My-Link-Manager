project = "linky"

runner {
  enabled = true

  data_source "git" {
    url  = "https://github.com/catsby/My-Link-Manager.git"
    ref = "refs/heads/dev"
  }
}


app "linky" {
  labels = {
    "service" = "linky",
    "env"     = "dev"
  }

  config {
    env = {
      PORT = dynamic("kubernetes", {
        name = "db-url"
        key  = "dburl"
      })
    }
  }

  build {
    use "pack" {}
    registry {
      use "docker" {
        # local registry
        image = "192.168.147.4:5000/linky"
        tag   = "1"
        # username = var.registry_username
        # password = var.registry_password
        local = false
      }
    }
  }

  deploy {
    use "kubernetes" {
      probe_path = "/"
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
