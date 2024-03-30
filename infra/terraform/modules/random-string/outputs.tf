output "is_enabled" {
  value       = local.is_enabled
  description = "Whether the module is enabled or not."
}

output "random_id" {
  value       = random_id.this
  description = "The random id generated."
}

output "random_password" {
  value       = random_password.this
  sensitive   = true
  description = "The random pet generated."
}

output "random_string" {
  value       = random_string.this
  description = "The random string generated."
}

output "random_uuid" {
  value       = random_uuid.this
  description = "The random uuid generated."
}
