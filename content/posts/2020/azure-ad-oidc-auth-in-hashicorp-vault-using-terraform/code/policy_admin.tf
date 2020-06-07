resource "vault_policy" "admin" {
  name = "admin"

  policy = <<EOT
# Manage auth methods broadly across Vault
path "auth/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Create, update, and delete auth methods
path "sys/auth/*" {
  capabilities = ["create", "update", "delete", "sudo"]
}

# List auth methods
path "sys/auth" {
  capabilities = ["read"]
}

# Create and manage ACL policies
path "sys/policies/acl/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# To list existing policies
path "sys/policies/acl" {
  capabilities = ["list"]
}

# List, create, update, and delete key/value secrets
path "secret/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Create and manage secrets engines broadly across Vault.
path "sys/mounts/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Read health checks
path "sys/health" {
  capabilities = ["read", "sudo"]
}

# To check capabilities of a token
path "sys/capabilities" {
  capabilities = ["create", "update"]
}

# To check capabilities of a token
path "sys/capabilities-self" {
  capabilities = ["create", "update"]
}
EOT
}
