terraform {
  required_providers {
    render = {
      source = "render-oss/render"
    }
  }
}

provider "render" {
  api_key = var.render_api_key
}

resource "render_web_service" "vetagenda" {
  name   = "vetagenda"
  plan   = "free"
  region = "oregon"

  runtime_source = {
    image = {
      url = "docker.io/simonvf10/vetagenda:${var.image_tag}"
    }
  }

  health_check_path = "/"
}
