terraform {
  required_providers {
    render = {
      source  = "render-oss/render"
    }
  }
}

provider "render" {
  api_key = var.render_api_key
}

variable "render_api_key" {
  description = "API Key de Render"
  type        = string
  sensitive   = true
}

variable "image_tag" {
  description = "Tag de la imagen Docker a desplegar"
  type        = string
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
