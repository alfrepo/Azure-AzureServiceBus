

# Create the resource group
resource "azurerm_resource_group" "rg" {
  name     = "${local.resource_group_name}"
  location = var.location
}



# Create the virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  location            = azurerm_resource_group.rg.location
  address_space       = ["${local.address_space}"]
  resource_group_name = azurerm_resource_group.rg.name
}

#subnets
resource "azurerm_subnet" "net_public" {
  name                  = "${var.prefix}-net_public"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name  = azurerm_virtual_network.vnet.name
  address_prefixes      = ["${local.address_space_public}"]
}

resource "azurerm_subnet" "net_private" {
  name                  = "${var.prefix}-net_private"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name  = azurerm_virtual_network.vnet.name
  address_prefixes      = ["${local.address_space_private}"]
}



# sec

# Network Security Groups

# PUBLIC
resource "azurerm_network_security_group" "nsg_public" {
  name                = "${var.prefix}-nsg-public"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow_internet_in"
    priority                    = 100
    direction                   = "Inbound"
    source_address_prefix       = "*"
    source_port_range          = "*"
    destination_address_prefix   = azurerm_subnet.net_public.address_prefixes[0] # Allow traffic from anywhere to public subnet
    destination_port_range       = "*"
    protocol                     = "*"
    access                      = "Allow"
  }
}

# Subnet Associations
resource "azurerm_subnet_network_security_group_association" "public_nsg_association" {
  subnet_id          = azurerm_subnet.net_public.id
  network_security_group_id = azurerm_network_security_group.nsg_public.id
}




resource "azurerm_network_security_group" "nsg_private" {
  name                = "${var.prefix}-nsg-private"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}


resource "azurerm_subnet_network_security_group_association" "private_nsg_association" {
  subnet_id          = azurerm_subnet.net_private.id
  network_security_group_id = azurerm_network_security_group.nsg_private.id
}



resource "azurerm_public_ip" "public_ip" {
  name                = "PublicIPForLB"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}


# Load Balancers (assuming Application Load Balancer - adjust for Network Load Balancer if needed)
resource "azurerm_lb" "public_lb" {
  name                = "${var.prefix}-lb-public"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name                = "${var.prefix}-lb-fe-public"
    public_ip_address_id = azurerm_public_ip.public_ip.id # Assuming you have a public IP defined
  }
}



resource "azurerm_lb_backend_address_pool" "public_lb_backend_pool" {
  name                = "${var.prefix}-lb-backend-pool-public"
  loadbalancer_id     = azurerm_lb.public_lb.id
}

#ctl shift p
# resource "azurerm_lb_routing_rule" "public_lb_rule" {
#   name                        = "${var.prefix}-lb-rule-public"
#   location                    = azurerm_resource_group.rg.location
#   resource_group_name         = azurerm_resource_group.rg.name
#   lb_id                       = azurerm_lb.public_lb.id
#   frontend_ip_configuration_id = azurerm_lb.public_lb.frontend_ip_configuration[0].id
#   backend_address_pool_id     = az
# }
