# Utilizar la VPC predeterminada de AWS

data "aws_vpc" "default" {
  default = true
}

# Grupo de seguridad para VetAgenda

resource "aws_security_group" "vetagenda_web" {
  name        = "${var.project_name}-web-sg"
  description = "Permite acceso web a VetAgenda"
  vpc_id      = data.aws_vpc.default.id

  # Permitir HTTP desde Internet

  ingress {
    description = "Acceso web HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permitir salida para actualizaciones y servicios AWS

  egress {
    description = "Salida IPv4"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-web-sg"
    Project     = var.project_name
    Environment = var.environment
  }
}
