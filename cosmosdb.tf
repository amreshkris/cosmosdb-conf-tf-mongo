# resource "azurerm_resource_group" "rg" {
#   name     = "rg-terraform-westeu-002"
#   location = "westeurope"
# }

resource "azurerm_cosmosdb_account" "cosmosdbaccount" {
  name                = "cosmos-mongo-001"
  location            = "westeurope"
  resource_group_name = "ohp-documentation-dev"
  offer_type          = "Standard"
  geo_location {
    location          = "westeurope"
    failover_priority = 0
  }
  kind                = "MongoDB"
  capabilities {
    name = "EnableMongo"
    //EnableCassandra, EnableGremlin, EnableMongo, EnableTable, 
  }
  consistency_policy {
    consistency_level       = "Session"  
  }
}

resource "azurerm_cosmosdb_mongo_database" "fooddatabase" {
  name                = "products-db"
  resource_group_name = azurerm_cosmosdb_account.cosmosdbaccount.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmosdbaccount.name
  throughput          = 400
  autoscale_settings {
      max_throughput = 4000
  }
}

resource "azurerm_cosmosdb_mongo_collection" "nutritioncollection" {
  name                = "nutrition-coll"
  resource_group_name = azurerm_cosmosdb_account.cosmosdbaccount.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmosdbaccount.name
  database_name       = azurerm_cosmosdb_mongo_database.fooddatabase.name

  #default_ttl_seconds = "4500"
  shard_key           = "foodCategory" 
  # autoscale_settings {
  #     max_throughput = 4000
  # }
  index {
    keys   = ["_id"]
    unique = true
  }
  index {
    keys   = ["productKey"]   
  }
}