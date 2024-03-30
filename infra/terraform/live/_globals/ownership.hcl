locals {
  # ---------------------------------------------------------------------------------------------------------------------
  # OWNERSHIP CONFIGURATION
  # Defines the ownership and organizational structuring for resources managed by Terragrunt. This setup facilitates
  # resource tagging and management, ensuring resources are easily identifiable and can be associated with specific
  # owners and layers within the infrastructure.
  #
  # The `ownership_tags` local encapsulates key metadata about the resource ownership:
  # - `owner`: Signifies the owner of the resources, typically an organization or project name. This is pivotal for
  #   access control, billing, and managing resources at scale. The owner is used as a key prefix in the S3 remote
  #   state backend configuration, enabling the segregation and concise identification of stacks by ownership.
  # - `layer`: Represents the specific layer or category of the infrastructure that the resource belongs to (e.g., 'infra',
  #   'app', 'data'). This classification aids in the logical separation and organization of resources within larger
  #   systems, supporting clarity and efficiency in infrastructure management.
  #
  # These tags are sourced from environment variables, allowing for dynamic assignment and flexibility across
  # different environments and deployment scenarios. Default values are provided to ensure the configuration is
  # robust and can operate with or without explicitly set environment variables.
  # ---------------------------------------------------------------------------------------------------------------------
  ownership_tags = {
    owner = get_env("TG_OWNER", "MakeMyInfra.cloud")  // Default owner: "MakeMyInfra.cloud"
    layer = get_env("TG_LAYER", "infra")              // Default layer: "infra"
  }
}
