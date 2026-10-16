output "folder_id" {
  description = "The Terraform ID of the folder, in the format `<org_id>:<folder_uid>`"
  value       = grafana_folder.collection.id
}

output "folder_uid" {
  description = "The UID of the folder"
  value       = grafana_folder.collection.uid
}
