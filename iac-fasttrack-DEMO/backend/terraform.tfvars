# Resource Group
resource_group_name = "rg-terraform-backend-timdemoft"
location            = "norwayeast"

# Storage Account (må være globalt unikt - bruk ditt eget navn)
storage_account_name = "timdemoft2025h25"

# Container for Terraform state
container_name = "tfstate"

# Key Vault (må være globalt unikt - skriv inn eget navn)
key_vault_name = "kv-timdemotf-123rsf"

# Azure AD / EntraID informasjon
service_principal_object_id = "a464ed7e-382f-4f47-b240-1c1dfe9b39ff"
user_object_id              = "3a0d3621-033b-42a4-a413-69c73af591b2"
