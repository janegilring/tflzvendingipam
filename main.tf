# Get new CIDR and TAG from IPAM API
data "external" "ipam-reservation" {
  program = [
    "pwsh",
    "${path.root}/scripts/fetchAddressPrefix.ps1",
    var.ipam_api_guid,
    "https://${var.ipam_app_name}.azurewebsites.net/api/spaces/${var.ipam_space}/blocks/${var.ipam_block}/reservations",
    var.vnet_size
  ]
}

# The landing zone module will be called once per landing_zone_*.yaml file
# in the data directory.
module "lz_vending" {
  source   = "Azure/lz-vending/azurerm"
  version  = "3.1.0"
  for_each = local.landing_zone_data_map

  location = each.value.location

  # subscription variables
  #subscription_alias_enabled = true
  #subscription_billing_scope = "/providers/Microsoft.Billing/billingAccounts/1234567/enrollmentAccounts/${each.value.billing_enrollment_account}"
  #subscription_display_name  = each.value.name
  #subscription_alias_name    = each.value.name
  #subscription_workload      = each.value.workload

  # existing subscription
  subscription_id = "00000000-0000-0000-0000-000000000000"

  # management group association variables
  subscription_management_group_association_enabled = true
  subscription_management_group_id                  = each.value.management_group_id

  # virtual network variables
  virtual_network_enabled = true
  virtual_networks = {
    vnet1 = {
      name                    = each.value.virtual_networks.name
      address_space           = [data.external.ipam-reservation.result.cidr] # Get from Azure IPAM 
      resource_group_name     = each.value.virtual_networks.resource_group_name
      hub_peering_enabled     = var.hub_peering_enabled
      hub_network_resource_id = var.hub_network_resource_id
      tags = { # Get from Azure IPAM 
        X-IPAM-RES-ID = data.external.ipam-reservation.result.id
      }
    }
  }

}

