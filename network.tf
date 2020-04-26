# Create virtual network
resource "azurerm_virtual_network" "az-compute-vnet" {
    name                = var.vnet_name
    address_space       = ["192.168.0.0/20"]
    location            = var.resource_group_location
    resource_group_name = azurerm_resource_group.az-compute-rg.name
}

# Create subnet
resource "azurerm_subnet" "az-compute-subnet" {
    name                 = var.subnet_name
    resource_group_name  = azurerm_resource_group.az-compute-rg.name
    virtual_network_name = azurerm_virtual_network.az-compute-vnet.name
    address_prefix       = "192.168.0.0/24"
}

# Create public IPs
resource "azurerm_public_ip" "az-compute-pubips" {
    name                         = var.public_ip_name
    location                     = var.resource_group_location
    resource_group_name          = azurerm_resource_group.az-compute-rg.name
    allocation_method            = "Static"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "az-compute-nsg" {
    name                = var.nsg_name
    location            = var.resource_group_location
    resource_group_name = azurerm_resource_group.az-compute-rg.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "HTTP"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "HTTPS"
        priority                   = 1003
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

# Create network interface
resource "azurerm_network_interface" "az-compute-nic" {
    name                      = var.nic_name
    location                  = var.resource_group_location
    resource_group_name       = azurerm_resource_group.az-compute-rg.name

    ip_configuration {
        name                          = "vmNicConfiguration"
        subnet_id                     = azurerm_subnet.az-compute-subnet.id
        private_ip_address_allocation = "dynamic"
        public_ip_address_id          = azurerm_public_ip.az-compute-pubips.id
    }
}

# Associate NSG with Subnet
resource "azurerm_subnet_network_security_group_association" "az-compute-nsg-subnet" {
  subnet_id                 = azurerm_subnet.az-compute-subnet.id
  network_security_group_id = azurerm_network_security_group.az-compute-nsg.id
}