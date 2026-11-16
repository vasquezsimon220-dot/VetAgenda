
# Rol IAM para la instancia EC2 de VetAgenda

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "vetagenda_ec2_role" {
  name               = "${var.project_name}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Project = var.project_name
  }
}

# Permisos limitados para CloudWatch

data "aws_iam_policy_document" "cloudwatch_permissions" {

  # Crear flujos y enviar registros
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/ec2/${var.project_name}:log-stream:*"
    ]
  }

  # Consultar los flujos de registros
  statement {
    effect = "Allow"

    actions = [
      "logs:DescribeLogStreams"
    ]

    resources = ["*"]
  }

  # Publicar métricas personalizadas
  statement {
    effect = "Allow"

    actions = [
      "cloudwatch:PutMetricData"
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "cloudwatch:namespace"
      values   = ["VetAgenda"]
    }
  }
}

# Política asociada al rol IAM

resource "aws_iam_role_policy" "cloudwatch_policy" {
  name   = "${var.project_name}-cloudwatch-policy"
  role   = aws_iam_role.vetagenda_ec2_role.id
  policy = data.aws_iam_policy_document.cloudwatch_permissions.json
}

# Perfil que permite asociar el rol a EC2

resource "aws_iam_instance_profile" "vetagenda_profile" {
  name = "${var.project_name}-instance-profile"
  role = aws_iam_role.vetagenda_ec2_role.name
}
