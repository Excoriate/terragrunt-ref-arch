# ---------------------------------------------------------------------------------------------------------------------
# COMMON TAGS CONFIGURATION
# Establishes a standardized set of metadata tags that are applicable to all infrastructure resources managed by
# Terraform and orchestrated by Terragrunt within the project. Tags are key-value pairs associated with resources that
# serve multiple purposes, including identification, organization, and governance of resources across cloud environments.
#
# Utilizing a consistent tagging strategy across all modules enhances the ability to:
# - Identify resources, their purpose, and their lifecycle owner at a glance.
# - Implement cost allocation, reporting, and optimization strategies based on tags.
# - Enforce security and compliance policies through tag-based resource segmentation.
# - Automate operations and management tasks that depend on the categorization of resources.
#
# This block defines a reusable set of global tags that can be incorporated into any module by including it in the
# `locals` block. Subsequently, these tags can be merged with module-specific tags and applied to resources in the
# Terraform `resource` blocks, ensuring a unified and comprehensive tagging approach across the project's infrastructure.
# ---------------------------------------------------------------------------------------------------------------------
locals {
  global_tags = {
    ManagedBy      = "Terraform"  // Indicates the tool used for resource provisioning.
    OrchestratedBy = "Terragrunt" // Indicates the tool used for workflow orchestration.
    Author         = "Alex Torres alex@makemyinfra.cloud"
    // The primary author of the Terraform/Terragrunt configuration.
    Owner          = "MakeMyInfra.cloud" // The organizational entity or project that owns the resource.
    Type           = "infrastructure" // Categorizes the resource within the broader infrastructure ecosystem.
    Maintainer     = "Alex Torres alex@makemyinfra.cloud"
    // Contact information for the individual or team responsible for maintaining the resource.
  }
}
