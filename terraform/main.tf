# Provider de AWS
provider "aws" {
  region = "us-east-2"
}

resource "aws_security_group" "k8s_sg" {
  name        = "k8s_security_group"
  description = "Allow SSH, HTTP, and Kubernetes traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Kubernetes API"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 30000
    to_port     = 30000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Instancia EC2 para el nodo de Kubernetes (Spot)
resource "aws_spot_instance_request" "k8s_node" {
  ami           = var.ami_id
  instance_type = var.instance_type
  spot_price    = var.spot_price
  key_name      = "my-ssh-key_1"

  vpc_security_group_ids = aws_security_group.k8s_sg.id != "" ? [aws_security_group.k8s_sg.id] : []

  tags = {
    Name = var.instance_name
  }

  lifecycle {
    create_before_destroy = true
  }

  user_data = <<-EOF
              #!/bin/bash

                # Actualizar los paquetes del sistema
                sudo apt-get update -y

                # Instalar dependencias necesarias
                sudo apt-get install -y apt-transport-https ca-certificates curl

                # Instalar Docker (necesario para Minikube)
                sudo apt-get install -y docker.io
                sudo systemctl enable docker
                sudo systemctl start docker

                # Agregar permisos para ejecutar Docker sin sudo
                sudo usermod -aG docker ubuntu

                # Descargar e instalar Minikube
                curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
                sudo install minikube-linux-amd64 /usr/local/bin/minikube

                # Descargar e instalar Kubectl
                sudo apt-get update -y && sudo apt-get install -y kubectl

                # Configurar permisos para Kubernetes
                sudo chmod -R 777 /home/ubuntu/.kube /home/ubuntu/.minikube
                sudo chown -R ubuntu:ubuntu /home/ubuntu/.kube /home/ubuntu/.minikube

                # Crear un servicio para iniciar Minikube automáticamente
                echo "[Unit]
                Description=Minikube Service
                After=docker.service

                [Service]
                User=ubuntu
                ExecStart=/usr/local/bin/minikube start --driver=none
                Restart=always

                [Install]
                WantedBy=multi-user.target" | sudo tee /etc/systemd/system/minikube.service

                # Habilitar el servicio de Minikube
                sudo systemctl daemon-reload
                sudo systemctl enable minikube.service
                sudo systemctl start minikube.service

                # Instalar Prometheus y Grafana (puedes modificar esto más tarde si lo haces desde el workflow)
                kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/main/bundle.yaml
                kubectl apply -f https://raw.githubusercontent.com/grafana/helm-charts/main/charts/grafana/templates/deployment.yaml

                # Imprimir un mensaje de éxito
                echo "Minikube, kubectl, Prometheus y Grafana instalados correctamente"
              EOF

}
