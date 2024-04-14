locals {
  # ---------------------------------------------------------------------------------------------------------------------
  # PROVIDER CONFIGURATIONS
  # This section centralizes the configuration of Terraform providers, such as Cloudflare, AWS, and Random, using Terraform's
  # heredoc syntax for inline definition. This approach allows for dynamic, environment-specific configuration of
  # providers through environment variables, enhancing the flexibility and security of provider setups. Direct use of
  # heredoc syntax within the Terragrunt configuration eliminates the need for external template files, streamlining
  # the codebase and simplifying the management of provider configurations.
  #
  # Each provider configuration includes:
  # - `enabled`: A flag (sourced from an environment variable) indicating whether the provider should be configured.
  #              This allows for conditional inclusion of providers based on the deployment context or environment.
  # - `content`: The Terraform configuration for the provider, including authentication details and any other
  #              provider-specific settings. Sensitive information is securely sourced from environment variables.
  #
  # This modular and dynamic approach to configuring providers supports best practices in security and infrastructure
  # code management, enabling selective provider use and environment-specific configurations without altering the
  # core codebase.
  # ---------------------------------------------------------------------------------------------------------------------
  providers = {
    random = {
      enabled = get_env("TG_PROVIDER_RANDOM_ENABLED", true)
      content = <<EOF
provider "random" {
  # The random provider does not require authentication, but this block is included
  # for consistency and to allow future configuration if necessary.
}
EOF
    }
    # Additional providers can be added here following the same pattern.
  }

  # ---------------------------------------------------------------------------------------------------------------------
  # PROVIDERS CONTENT
  # Generate the providers' configuration content only for enabled providers.
  # ---------------------------------------------------------------------------------------------------------------------
  providers_content = [
    for provider, details in local.providers : details.content
    if details.enabled && details.content != null
  ]
}
