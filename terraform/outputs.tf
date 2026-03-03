output "instance_ip" {
  description = "IP público da instância"
  value       = google_compute_instance.app_server.network_interface[0].access_config[0].nat_ip
}

output "app_url" {
  description = "URL da aplicação"
  value       = "http://${google_compute_instance.app_server.network_interface[0].access_config[0].nat_ip}"
}

output "cluster_name" {
  description = "Nome do cluster GKE"
  value       = google_container_cluster.devops_cluster.name
}

output "cluster_location" {
  description = "Localização do cluster"
  value       = google_container_cluster.devops_cluster.location
}