locals {
  # ---------------------------------------------------------------------------------------------------------------------
  # BINARIES VERSION CONFIGURATION
  # Specifies the versions of Terraform and Terragrunt binaries to be used for infrastructure provisioning and
  # orchestration. Ensuring consistency in binary versions across all environments and team members is crucial for
  # the reliability and predictability of infrastructure changes. Version specification supports both direct
  # declaration and overrides via environment variables, providing flexibility and adaptability to different
  # development and deployment contexts.
  #
  # - `terraform_version`: Sets the default version of the Terraform binary to be used. It can be overridden
  #   by setting the `TG_CONFIG_TERRAFORM_VERSION` environment variable, allowing for dynamic version management
  #   based on the execution environment or specific project requirements.
  #
  # - `terragrunt_version`: Establishes the default version of the Terragrunt binary. Similar to Terraform, this
  #   version can be overridden through the `TG_CONFIG_TERRAGRUNT_VERSION` environment variable, facilitating
  #   version synchronization with Terraform or alignment with specific features or fixes in Terragrunt releases.
  #
  # Adopting a managed approach to versioning for these critical tools helps in avoiding "works on my machine"
  # issues, streamlines CI/CD pipelines, and ensures that infrastructure deployments are executed against tested
  # and approved versions of Terraform and Terragrunt.
  # ---------------------------------------------------------------------------------------------------------------------
  terraform_version  = get_env("TG_CONFIG_TERRAFORM_VERSION", "1.6.1")  // Default Terraform version: 1.6.1
  terragrunt_version = get_env("TG_CONFIG_TERRAGRUNT_VERSION", "0.42.8") // Default Terragrunt version: 0.42.8
}
