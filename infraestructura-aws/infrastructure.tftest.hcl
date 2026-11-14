
# Pruebas automatizadas de VetAgenda

mock_provider "aws" {
  mock_data "aws_iam_policy_document" {
    defaults = {
      json = jsonencode({
        Version = "2012-10-17"
        Statement = []
      })
    }
  }
}

run "default_configuration" {
  command = plan

  assert {
    condition     = output.project_name == "vetagenda"
    error_message = "El nombre del proyecto debe ser vetagenda."
  }

  assert {
    condition     = output.environment == "development"
    error_message = "El entorno debe ser development."
  }

  assert {
    condition     = output.aws_region == "us-east-1"
    error_message = "La region debe ser us-east-1."
  }
}
