project = "linky"

variable "repcount" {
  type    = number
  default = 1
}

runner {
  enabled = true

  data_source "git" {
    url  = "https://github.com/catsby/My-Link-Manager.git"
    # path = "kubernetes/nodejs"

    ref = "refs/heads/dev"
  }
}


app "linky" {
  labels = {
    "service" = "linky",
    "env"     = "dev"
  }

  build {
    use "pack" {}
    registry {
      use "docker" {
        # local registry
        # image = "192.168.147.4:5000/linky"
        image = "clint-C02C60MUMD6R.local:5000/linky"
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
    }
  }
}
