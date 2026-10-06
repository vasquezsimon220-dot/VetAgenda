variable "render_api_key" {
  description = "API Key de Render"
  type        = string
  sensitive   = true
}

variable "image_tag" {
  description = "Tag de la imagen Docker de VetAgenda"
  type        = string
}
