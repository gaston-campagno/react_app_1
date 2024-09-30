# Salida que muestra la IP pública de la instancia
output "ec2_instance_public_ip" {
  value = aws_spot_instance_request.k8s_node.public_ip
}

output "existing_key_name" {
  value = data.aws_key_pair.existing_key.key_name
}

output "ssh_private_key" {
  value     = tls_private_key.ssh_key[0].private_key_pem
  sensitive = true # Marca la clave como sensible para ocultarla en la salida
}
# Salida que muestra el ID de la instancia
output "ec2_instance_id" {
  value = aws_spot_instance_request.k8s_node.id
}
