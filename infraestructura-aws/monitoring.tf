
# Grupo de registros para VetAgenda

resource "aws_cloudwatch_log_group" "vetagenda_logs" {
  name              = "/aws/ec2/${var.project_name}"
  retention_in_days = 7

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# Alarma para detectar uso elevado de CPU

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.project_name}-high-cpu"
  alarm_description   = "Detecta uso elevado de CPU en VetAgenda"

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  treat_missing_data = "notBreaching"

  tags = {
    Project = var.project_name
  }
}
