locals {
  # ---------------------------------------------------------------------------------------------------------------------
  # GLOBAL PROVIDER CONFIGURATIONS
  # This section outlines the centralized configuration for Terraform providers such as Cloudflare and AWS,
  # applicable across all Terragrunt child configurations in the project. Using Terraform's heredoc syntax,
  # we define providers' settings inline, promoting dynamic, environment-specific configurations through
  # environment variables for enhanced flexibility and security.
  #
  # This configuration is pivotal as it merges with 'providers.tf' settings generated in all child configurations,
  # ensuring consistency and minimizing redundancy across the codebase. Sensitive information like API keys
  # is securely sourced from environment variables, adhering to best practices in security and configuration management.
  #
  # Key details include:
  # - `enabled`: A boolean, sourced from environment variables, controls whether the provider is active.
  # - `content`: Contains the Terraform code for setting up the provider, emphasizing secure practices by pulling
  #              sensitive credentials from environment settings.
  #
  # The approach allows for selective activation of providers per environment without altering core code,
  # thus supporting a modular, secure, and maintainable infrastructure codebase.
  # ---------------------------------------------------------------------------------------------------------------------
  providers = {
    # Example for Cloudflare, uncomment and modify as necessary
    # cloudflare = {
    #   enabled = get_env("TG_PROVIDER_CLOUDFLARE_ENABLED", true)
    #   content = <<-EOF
    # provider "cloudflare" {
    #   email   = "${get_env("CLOUDFLARE_EMAIL", "email@example.com")}"
    #   api_key = "${get_env("CLOUDFLARE_API_KEY", "your_cloudflare_api_key")}"
    # }
    # EOF
    # },
    # Example for AWS, with conditional enablement
    # aws = {
    #   enabled = get_env("TG_PROVIDER_AWS_ENABLED", false)
    #   content = <<-EOF
    # provider "aws" {
    #   region = "us-west-2"
    #   access_key = "${get_env("AWS_ACCESS_KEY")}"
    #   secret_key = "${get_env("AWS_SECRET_KEY")}"
    # }
    # EOF
    # },
    # Additional providers can be added here following the same pattern.
  }

  # ---------------------------------------------------------------------------------------------------------------------
  # PROVIDERS CONTENT
  # Aggregates provider configurations into a cohesive block only for those that are enabled, to be injected into
  # the respective 'providers.tf' files across all child configurations. This ensures that all Terragrunt modules
  # have access to a consistent set of provider settings, potentially overridden by local definitions if specified.
  # ---------------------------------------------------------------------------------------------------------------------
  providers_content = [
    for provider, details in local.providers : details.content
    if details.enabled && details.content != null
  ]
}
