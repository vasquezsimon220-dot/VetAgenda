
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

  mock_data "aws_caller_identity" {
    defaults = {
      account_id = "123456789012"
      arn        = "arn:aws:iam::123456789012:user/test"
      user_id    = "test-user"
    }
  }

  mock_data "aws_ami" {
    defaults = {
      id = "ami-12345678"
    }
  }
}

run "default_configuration" {
  command = plan

  # Validar configuración general

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

  # Validar instancia EC2

  assert {
    condition     = aws_instance.vetagenda.instance_type == "t3.micro"
    error_message = "La instancia EC2 debe utilizar t3.micro."
  }

  assert {
    condition     = aws_instance.vetagenda.root_block_device[0].volume_size == 8
    error_message = "El disco de EC2 debe tener 8 GB."
  }

  # Validar monitoreo CloudWatch

  assert {
    condition     = aws_cloudwatch_log_group.vetagenda_logs.retention_in_days == 7
    error_message = "Los registros deben conservarse durante 7 dias."
  }

  assert {
    condition     = aws_cloudwatch_metric_alarm.high_cpu.threshold == 80
    error_message = "La alarma de CPU debe tener un umbral del 80 por ciento."
  }

  # Validar auditoria CloudTrail

  assert {
    condition     = aws_cloudtrail.vetagenda.enable_logging == true
    error_message = "CloudTrail debe tener habilitado el registro de eventos."
  }

  assert {
    condition     = aws_cloudtrail.vetagenda.include_global_service_events == true
    error_message = "CloudTrail debe registrar eventos globales."
  }
}

