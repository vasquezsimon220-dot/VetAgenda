
# Validaciones de configuracion para VetAgenda

check "valid_project_name" {
  assert {
    condition     = length(var.project_name) > 0
    error_message = "El nombre del proyecto no puede estar vacio."
  }
}

check "valid_environment" {
  assert {
    condition = contains(
      ["development", "testing", "production"],
      var.environment
    )
    error_message = "El entorno debe ser development, testing o production."
  }
}

check "valid_aws_region" {
  assert {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.aws_region))
    error_message = "La region AWS debe tener un formato valido."
  }
}
