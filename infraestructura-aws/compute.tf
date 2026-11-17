
# Obtener la imagen oficial de Ubuntu Server 24.04 LTS

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Instancia EC2 para VetAgenda

resource "aws_instance" "vetagenda" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.vetagenda_profile.name

  # Grupo de seguridad personalizado
  vpc_security_group_ids = [
    aws_security_group.vetagenda_web.id
  ]

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  monitoring = false

  # Instalar Nginx y CloudWatch Agent
  user_data = <<-EOF
    #!/bin/bash
    set -e

    apt-get update
    apt-get install -y nginx wget

    # Iniciar servidor web
    systemctl enable nginx
    systemctl start nginx

    # Publicar página VetAgenda
    echo '${base64encode(file("${path.module}/../web/index.html"))}' | base64 -d > /var/www/html/index.html

    # Descargar CloudWatch Agent
    wget https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/amd64/latest/amazoncloudwatch-agent.deb

    dpkg -i -E ./amazoncloudwatch-agent.deb

    # Configurar monitoreo
    cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<'CONFIG'
    {
      "agent": {
        "metrics_collection_interval": 300,
        "logfile": "/opt/aws/amazoncloudwatch-agent/logs/amazon-cloudwatch-agent.log"
      },
      "metrics": {
        "namespace": "VetAgenda",
        "metrics_collected": {
          "mem": {
            "measurement": ["mem_used_percent"]
          },
          "disk": {
            "measurement": ["used_percent"],
            "resources": ["/"]
          }
        }
      },
      "logs": {
        "logs_collected": {
          "files": {
            "collect_list": [
              {
                "file_path": "/var/log/syslog",
                "log_group_name": "/aws/ec2/${var.project_name}",
                "log_stream_name": "{instance_id}-syslog"
              }
            ]
          }
        }
      }
    }
    CONFIG

    /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
      -a fetch-config \
      -m ec2 \
      -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
      -s
  EOF

  tags = {
    Name        = "${var.project_name}-server"
    Project     = var.project_name
    Environment = var.environment
  }
}

