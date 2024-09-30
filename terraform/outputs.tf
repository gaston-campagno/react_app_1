output "ec2_instance_public_ip" {
  value = aws_spot_instance_request.k8s_node[0].public_ip # Accede a la primera instancia
}

output "ec2_instance_id" {
  value = aws_spot_instance_request.k8s_node[0].id # Accede a la primera instancia
}