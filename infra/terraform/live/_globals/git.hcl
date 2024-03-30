# ---------------------------------------------------------------------------------------------------------------------
# GIT CONFIGURATION
# This section provides a centralized configuration for Git-related settings used across Terragrunt configurations.
# It's designed to define common Git parameters, such as the base URL of the Git repository, facilitating the reuse
# of these parameters in various parts of the Terragrunt configuration. By centralizing Git settings here, we ensure
# consistency and ease of maintenance for Git operations within the project, such as module sourcing and versioning.
# ---------------------------------------------------------------------------------------------------------------------
locals {
  # Defines the base URL for Git repositories. This URL is prefixed to repository-specific paths
  # to form complete URLs for Terraform module sourcing. The use of SSH-based URLs ('git@')
  # suggests a preference for SSH authentication, offering a secure method for accessing private repositories.
  github_base_url = "git::git@github.com:"
  local_base_url  = "../../../../../modules"
}
