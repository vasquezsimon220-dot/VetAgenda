variable "aws_region" {
  description = "Region de AWS donde se desplegara VetAgenda"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  default     = "vetagenda"
}

variable "environment" {
  description = "Entorno de despliegue"
  type        = string
  default     = "development"
}
