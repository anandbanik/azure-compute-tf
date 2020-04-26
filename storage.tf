# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = azurerm_resource_group.az-compute-rg.name
    }

    byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "storageaccounttfdemo" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = azurerm_resource_group.az-compute-rg.name
    location                    = var.resource_group_location
    account_tier                = "Standard"
    account_replication_type    = "LRS"

}