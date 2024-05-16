locals {
  # ---------------------------------------------------------------------------------------------------------------------
  # PROVIDER CONFIGURATIONS
  # This section centralizes the configuration of Terraform providers, such as Cloudflare and AWS, using Terraform's
  # heredoc syntax for inline definition. This approach allows for dynamic, environment-specific configuration of
  # providers through environment variables, enhancing the flexibility and security of provider setups. Direct use of
  # heredoc syntax within the Terragrunt configuration eliminates the need for external template files, streamlining
  # the codebase and simplifying the management of provider configurations.
  #
  # Each provider configuration includes:
  # - `enabled`: A flag (sourced from an environment variable) indicating whether the provider should be configured.
  #              This allows for conditional inclusion of providers based on the deployment context or environment.
  # - `content`: The Terraform configuration for the provider, including authentication details and any other
  #              provider-specific settings. Sensitive information, such as API keys, is securely sourced from
  #              environment variables.
  #
  # This modular and dynamic approach to configuring providers supports best practices in security and infrastructure
  # code management, enabling selective provider use and environment-specific configurations without altering the
  # core codebase.
  # ---------------------------------------------------------------------------------------------------------------------
  providers = {
    cloudflare = {
      enabled = get_env("TG_PROVIDER_CLOUDFLARE_ENABLED", true)
      content = <<-EOF
provider "cloudflare" {
  email   = "${get_env("CLOUDFLARE_EMAIL", "my@email.com")}"
  api_key = "${get_env("CLOUDFLARE_API_KEY", "0f2dsssda8f3b8")}"
}
EOF
    },
    # Additional providers can be added here following the same pattern.
  }

  # ---------------------------------------------------------------------------------------------------------------------
  # PROVIDERS CONTENT
  # Generate the providers' configuration content only for enabled providers.
  # ---------------------------------------------------------------------------------------------------------------------
  providers_content = [
    for provider, details in local.providers : details.content
    if details.enabled && details.content != ""
  ]
}
