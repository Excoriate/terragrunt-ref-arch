resource "random_id" "this" {
  byte_length = 8
}

resource "random_password" "this" {
  length  = 16
  special = false
}

resource "random_string" "this" {
  length  = 16
  special = false
}

resource "random_uuid" "this" {
}
