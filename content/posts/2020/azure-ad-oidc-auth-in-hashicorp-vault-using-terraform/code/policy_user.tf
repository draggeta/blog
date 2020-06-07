resource "vault_policy" "user" {
  name = "user"

  policy = <<EOT
# List top level folders only
path "secret/metadata/+" {
  capabilities = ["list"]
}

# CRUD on entries, but only latest.
path "secret/data/*" {
  capabilities = ["create", "read", "update", "delete"]
}

# Delete, undelete, and destroy entries
path "secret/+/dev/*" {
  capabilities = ["update"]
}

# List folders, read metadata and delete all versions
path "secret/metadata/*" {
  capabilities = ["read","delete", "list"]
}
EOT
}
