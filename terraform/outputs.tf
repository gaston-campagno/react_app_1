# Salida que muestra la IP pública de la instancia
output "ec2_instance_public_ip" {
  value = aws_spot_instance_request.k8s_node.public_ip
}

output "ssh_private_key" {
  value = length(data.aws_key_pair.existing_key.key_name) == 0 ? tls_private_key.ssh_key[0].private_key_pem : "No key created"
  sensitive = true
}

output "key_name" {
  value = aws_key_pair.my_key[0].key_name
}
# Salida que muestra el ID de la instancia
output "ec2_instance_id" {
  value = aws_spot_instance_request.k8s_node.id
}
