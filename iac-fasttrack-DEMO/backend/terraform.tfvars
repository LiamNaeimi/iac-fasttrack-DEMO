# Resource Group
resource_group_name = "rg-terraform-backend-liamx25"
location            = "norwayeast"

# Storage Account (må være globalt unikt - bruk ditt eget navn)
storage_account_name = "timdemoft2025h25liamx25"

# Container for Terraform state
container_name = "tfstateliamx25"

# Key Vault (må være globalt unikt - skriv inn eget navn)
key_vault_name = "kv-liamx25-123rsf"

# Azure AD / EntraID informasjon
service_principal_object_id = "1216a7b6-9b6a-4b2a-b540-8285d445053b"
user_object_id              = "5a5b83d3-e82f-4530-9c36-d1067cd60477"
