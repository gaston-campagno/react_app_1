# Salida que muestra la IP pública de la instancia
output "ec2_instance_public_ip" {
  value = aws_instance.k8s_node.public_ip
}

# Salida que muestra el ID de la instancia
output "ec2_instance_id" {
  value = aws_instance.k8s_node.id
}
