# Enable Open ID Connect authentication backend with AAD configuration
resource "vault_jwt_auth_backend" "azure_oidc" {
  description = "Azure Authentication"
  path        = "oidc"
  type        = "oidc"

  oidc_discovery_url = "https://login.microsoftonline.com/e9c80aca-2294-4619-8f10-888f8b6682e8/v2.0"
  oidc_client_id     = "6d14e904-1d87-483e-82e3-8bc513e15c0d"
  oidc_client_secret = "2n08rIqfH=PJ@pGy_jh3!eNSFC?_Vh_9"

  # Sets "oidc" as the default role so users don't need to specify it for each
  # login
  default_role = "oidc"

  # Makes the OIDC login a separate tab on the web UI login page, allowing for
  # quickier login.
  tune {
    listing_visibility = "unauth"
    default_lease_ttl  = "8h"
    max_lease_ttl      = "16h"
  }
}

# A role for Vault. Basically defines the type of access wanted. As Azure AD
# App Roles will be used, "group_claim" is set to "roles".
resource "vault_jwt_auth_backend_role" "azure_oidc_user" {
  backend        = vault_jwt_auth_backend.azure_oidc.path
  role_name      = "oidc"
  token_policies = ["default"]

  user_claim            = "email"
  role_type             = "oidc"
  allowed_redirect_uris = ["http://localhost:8250/oidc/callback", "http://localhost:8200/ui/vault/auth/oidc/oidc/callback"]
  groups_claim          = "roles"
  oidc_scopes           = ["https://graph.microsoft.com/.default", "profile", "email"]

  # Remove in production. Logs sensitive information. Handy for testing
  verbose_oidc_logging = true
}


resource "vault_identity_group" "user" {
  name     = "user"
  type     = "external"
  policies = ["user"]
}

resource "vault_identity_group" "admin" {
  name     = "admin"
  type     = "external"
  policies = ["admin"]
}

resource "vault_identity_group_alias" "user_alias_azure_vault_user" {
  name           = "VaultUser"
  mount_accessor = vault_jwt_auth_backend.azure_oidc.accessor
  canonical_id   = vault_identity_group.user.id
}

resource "vault_identity_group_alias" "admin_alias_azure_vault_admin" {
  name           = "VaultAdmin"
  mount_accessor = vault_jwt_auth_backend.azure_oidc.accessor
  canonical_id   = vault_identity_group.admin.id
}
