terraform {
  required_providers {
    render = {
      source  = "render-oss/render"
      version = "1.9.1"
    }
  }
}

provider "render" {
  api_key = var.render_api_key
}

resource "render_web_service" "vetagenda" {
  name   = "vetagenda"
  plan   = "starter"
  region = "oregon"

  runtime_source = {
    image = {
      image_url = "docker.io/simonvf10/vetagenda"
      tag       = var.image_tag
    }
  }

  health_check_path = "/"
}
