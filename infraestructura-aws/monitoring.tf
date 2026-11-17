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
  datapoints_to_alarm = 2

  metric_name = "CPUUtilization"
  namespace   = "AWS/EC2"
  period      = 300
  statistic   = "Average"
  threshold   = 80
  unit        = "Percent"

  treat_missing_data = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.vetagenda.id
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# Dashboard de monitoreo de VetAgenda

resource "aws_cloudwatch_dashboard" "vetagenda_dashboard" {
  dashboard_name = "${var.project_name}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "CPUUtilization",
              "InstanceId",
              aws_instance.vetagenda.id
            ]
          ]

          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "Uso de CPU - VetAgenda"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "NetworkIn",
              "InstanceId",
              aws_instance.vetagenda.id
            ],
            [
              "AWS/EC2",
              "NetworkOut",
              "InstanceId",
              aws_instance.vetagenda.id
            ]
          ]

          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "Tráfico de red - VetAgenda"
        }
      },
      {
        type   = "alarm"
        x      = 0
        y      = 6
        width  = 24
        height = 3

        properties = {
          alarms = [
            aws_cloudwatch_metric_alarm.high_cpu.arn
          ]
          title = "Estado de alarma de CPU"
        }
      }
    ]
  })
}
