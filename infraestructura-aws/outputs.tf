
output "project_name" {
  description = "Nombre del proyecto desplegado"
  value       = var.project_name
}

output "environment" {
  description = "Entorno de despliegue"
  value       = var.environment
}

output "aws_region" {
  description = "Region AWS configurada"
  value       = var.aws_region
}
