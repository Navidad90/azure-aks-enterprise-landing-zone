terraform {
  backend "azurerm" {
    resource_group_name  = "rg-weu-aks-ent-tfstate"
    storage_account_name = "stweuaksenttfstate"
    container_name       = "tfstate"
    key                  = "weu-aks-enterprise-baseline-dev.tfstate"
  }
}
