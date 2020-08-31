resource "azurerm_resource_group" "JST-GITLAB" {
  name     = "JST-GITLAB-RG"
  location = "West Europe"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "jst-gitlab-vnet" {
  name                = "jst-gitlab-vnet"
  resource_group_name = azurerm_resource_group.JST-GITLAB.name
  location            = azurerm_resource_group.JST-GITLAB.location
  address_space       = ["172.33.0.0/16"]
}

resource "azurerm_subnet" "jst-gitlab-subnet1" {
  name                 = "jst-gitlab-subnet1"
  resource_group_name  = azurerm_resource_group.JST-GITLAB.name
  virtual_network_name = azurerm_virtual_network.jst-gitlab-vnet.name
  address_prefixes     = ["172.33.0.0/24"]
}

resource "azurerm_network_security_group" "jst-gitlab-nsg1" {
  name                = "jst-gitlab-nsg1"
  location            = azurerm_resource_group.JST-GITLAB.location
  resource_group_name = azurerm_resource_group.JST-GITLAB.name
}

resource "azurerm_network_security_rule" "jst-http-8080" {
  name                        = "http8080"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.JST-GITLAB.name
  network_security_group_name = azurerm_network_security_group.jst-gitlab-nsg1.name
}

resource "azurerm_network_security_rule" "jst-https-8443" {
  name                        = "https8443"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.JST-GITLAB.name
  network_security_group_name = azurerm_network_security_group.jst-gitlab-nsg1.name
}

resource "azurerm_network_security_rule" "jst-ssh-2022" {
  name                        = "ssh2022"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "2022"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.JST-GITLAB.name
  network_security_group_name = azurerm_network_security_group.jst-gitlab-nsg1.name
}

resource "azurerm_network_security_rule" "jst-ssh-22" {
  name                        = "ssh22"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.JST-GITLAB.name
  network_security_group_name = azurerm_network_security_group.jst-gitlab-nsg1.name
}

resource "azurerm_subnet_network_security_group_association" "jst-gitlab-subnet1-nsg1" {
  subnet_id                 = azurerm_subnet.jst-gitlab-subnet1.id
  network_security_group_id = azurerm_network_security_group.jst-gitlab-nsg1.id
}

resource "azurerm_public_ip" "jst-gitlab-ip1" {
  name                = "jst-gitlab-ip1"
  resource_group_name = azurerm_resource_group.JST-GITLAB.name
  location            = azurerm_resource_group.JST-GITLAB.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "jst-gitlab-nic1" {
  name                = "jst-gitlab-nic1"
  location            = azurerm_resource_group.JST-GITLAB.location
  resource_group_name = azurerm_resource_group.JST-GITLAB.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.jst-gitlab-subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jst-gitlab-ip1.id
  }
}

resource "azurerm_linux_virtual_machine" "jst-gitlab" {
  name                = "jst-gitlab"
  computer_name       = "gitlab"
  resource_group_name = azurerm_resource_group.JST-GITLAB.name
  location            = azurerm_resource_group.JST-GITLAB.location
  size                = "Standard_B2ms"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.jst-gitlab-nic1.id,
  ]

  admin_ssh_key {
        public_key = "ssh-rsa insert-your-key-here\n"
        username = "adminuser"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = "30"
    name                 = "jst-gitlab-disk1"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18_04-lts-gen2"
    version   = "latest"
  }
}
