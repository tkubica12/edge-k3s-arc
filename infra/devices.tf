# K3s
variable "amount" {
  default = 5
}

resource "azurerm_network_interface" "k3s" {
  count               = var.amount
  name                = "k3s-nic-${count.index}"
  location            = azurerm_resource_group.edge.location
  resource_group_name = azurerm_resource_group.edge.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.edge.id
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_linux_virtual_machine" "k3s" {
  count               = var.amount
  name                = "k3s-${count.index}"
  resource_group_name = azurerm_resource_group.edge.name
  location            = azurerm_resource_group.edge.location
  size                = "Standard_B2s"
  admin_username      = "tomas"
  network_interface_ids = [
    azurerm_network_interface.k3s[count.index].id,
  ]

  admin_ssh_key {
    username   = "tomas"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDNN/xTE/WrpgK5nROtHupBqlHHVXQAP3c2wcvDz8PO/xLIawd8bPtrbKTmJX3TEVYe+WwQAc5K2XZrzaVGmiZeZSsHhiG3lX9kh2BbxZ9WLtLwta5gmkby4HTdk4sD3yeFFfrrdqHip5+DGl/OijUZC4ihMV6bS9P8jmugxtQKMkIeUC41HaShkXM44rnTRAvQoDr9iJZrAuuKDIZwhIv3ax8J0eu8WaRAVa5t8uZjL2Tv2QmMyK4oZtj89aVsSQyn26T3omNXfJVC/0kltM/Iu3jYXoRZz+8zAOhpTk4C6IsquM0FYsjkNBiip7/9rQCVArNMK6/Hojdl04UvVbi/QZRh4wAc9Ii49ZvD6bIxa0fc3uNl0I/EHN+BknkfzyKXuZ31roTn6xtWLcGrNN9zU+pX9Y69BvRaz2rIeYTGkQ//N7XZRV+Iv4cCEOwOrDxA61xcNDQVMLzW79Q1gQp2vD5Mybn0/LD5hb1TlAxkJfZXfdabDh/BnEEOuZFZLrgMU4c39OeQMWMV/c1gctytmLiIg4LcjhLzyzYwAShFwo+Ajkb46GWyYJD5tVnaqtf5AC6oY6C0linO6UbmpBqoWuUvM+Z6biTEP+qrUhxQ+4XVC4DwPz9Tf+YuKRvxMS5bhVxEcAFdwi1NAwfOXRMNdHRp730uslHz69gR9s3pIw=="
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "k3s" {
  count                = var.amount
  name                 = "k3s"
  virtual_machine_id   = azurerm_linux_virtual_machine.k3s[count.index].id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "fileUris": ["https://raw.githubusercontent.com/tkubica12/edge-k3s-arc/master/scripts/arc-k3s-install.sh"]
    }
SETTINGS

  protected_settings = <<PROTECTEDSETTINGS
    {
        "commandToExecute": "./arc-k3s-install.sh ${var.client_id} ${var.client_secret} ${var.tenant_id} ${azurerm_log_analytics_workspace.arc.workspace_id} ${azurerm_log_analytics_workspace.arc.primary_shared_key} ${azurerm_log_analytics_workspace.arc.id} ${azurerm_resource_group.edge.name} k3s-${count.index}"
    }
PROTECTEDSETTINGS

}
