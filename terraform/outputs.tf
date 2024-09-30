# Salida que muestra la IP pública de la instancia
output "ec2_instance_public_ip" {
  value = aws_spot_instance_request.k8s_node.public_ip
}
output "key_name" {
  value = length(aws_key_pair.my_key) > 0 ? aws_key_pair.my_key[0].key_name : "No key created"
}

output "ssh_private_key" {
  value     = length(tls_private_key.ssh_key) > 0 ? tls_private_key.ssh_key[0].private_key_pem : "No private key created"
  sensitive = true
}
# Salida que muestra el ID de la instancia
output "ec2_instance_id" {
  value = aws_spot_instance_request.k8s_node.id
}
