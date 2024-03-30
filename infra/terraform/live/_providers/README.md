# `_providers` Directory Overview 🌍

The `_providers` directory is integral to managing Terraform provider configurations in a Terragrunt-driven infrastructure. It centralizes the setup for various providers like Cloudflare, AWS, etc., leveraging the dynamic capabilities of Terragrunt and Terraform for environment-specific configurations.

The config.hcl file within the _providers directory serves as a central point for configuring Terraform providers such as Cloudflare, AWS, and others. It utilizes Terraform's heredoc syntax for inline definitions, allowing for dynamic and environment-specific configurations.

## Key Features 🔑

* Dynamic Configuration: Provider configurations are defined inline, enabling dynamic adjustments based on environment variables. This method supports conditional provider setup, making it possible to enable or disable specific providers as needed.
* Enhanced Security: Sensitive details, like API keys and email addresses, are securely injected using environment variables, avoiding hard-coded credentials within the configuration files.
* Modularity: This approach promotes a modular configuration strategy, where provider settings can be easily adjusted without modifying the core codebase.
Usage 🛠️

# Usage 🛠️

1. Conditional Inclusion: Providers are conditionally included based on their enabled status, which is determined by environment variables. This allows for precise control over which providers are activated in different environments or deployment contexts.
2. Streamlined Management: The direct use of heredoc syntax for provider configurations streamlines the Terraform codebase by eliminating the need for separate template files for each provider, simplifying management and updates.

## Best Practices 📝


* Environment Variables: Utilize environment variables for all sensitive information and to toggle the inclusion of different providers. This practice not only secures sensitive details but also provides flexibility across different deployment environments.
* Provider Management: Regularly review and update the config.hcl file to reflect changes in provider requirements or to introduce new providers as your infrastructure evolves.
* Documentation: Keep detailed documentation of each provider's configuration, including required environment variables and any specific setup instructions, to ensure clarity and ease of use for team members.

## Configuration File: `config.hcl`

The sole configuration file within this directory, `config.hcl`, orchestrates the definition and conditional inclusion of Terraform providers.

### Key Aspects of `config.hcl` 🗝️

*
* **Dynamic Provider Configuration**: Using Terraform's heredoc syntax, `config.hcl` allows for inline provider definitions that can be dynamically adjusted with environment variables.
*
* **Security and Flexibility**: Sensitive information (e.g., API keys) is passed via environment variables, enhancing security and providing the flexibility to alter configurations per deployment environment.
*
* **Modularity**: This setup promotes a modular approach, enabling the selective use of providers without altering the core codebase.

### How It Works 🔧

```hcl
locals {
  providers = {
    cloudflare = {
      enabled = get_env("TG_PROVIDER_CLOUDFLARE_ENABLED", false)
      content = <<EOF
provider "cloudflare" {
  email   = "${get_env("CLOUDFLARE_EMAIL", "")}"
  api_key = "${get_env("CLOUDFLARE_API_KEY", "")}"
}
EOF
    },
    // Additional providers follow the same pattern.
  }

  providers_content = [
    for provider, details in local.providers : details.content
    if details.enabled
  ]
}
```

And then, it's used in the `terragrunt.hcl` file like this:

```hcl
generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = join("\n", local.providers_cfg.locals.providers_content)
}
```
