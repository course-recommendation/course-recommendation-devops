resource "github_actions_secret" "stapp_api_token" {
  repository      = "course-recommendation-react"
  secret_name     = "AZURE_STATIC_WEB_APPS_API_TOKEN"
  value           = azurerm_static_web_app.stapp.api_key
}
