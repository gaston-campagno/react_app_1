# Salida que muestra la IP pública de la instancia
output "ec2_instance_public_ip" {
  value = aws_spot_instance_request.k8s_node.public_ip
}

output "existing_key_name" {
  value = data.aws_key_pair.existing_key.key_name
}

output "existing_key" {
  value = length(data.aws_key_pair.existing_key.key_name) > 0 ? data.aws_key_pair.existing_key.key_name : "No key found"
}
# Salida que muestra el ID de la instancia
output "ec2_instance_id" {
  value = aws_spot_instance_request.k8s_node.id
}
