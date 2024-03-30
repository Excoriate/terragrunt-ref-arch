locals {
  # ---------------------------------------------------------------------------------------------------------------------
  # MODULE CONFIGURATION
  # This section is dedicated to configuring specific Terraform modules used within this Terragrunt configuration.
  # It allows for the customization of module variables, the behavior of the module, and even Terragrunt's execution
  # logic in relation to the module. This flexibility is crucial for scenarios where specific adjustments or overrides
  # are necessary, such as:
  # - Testing new module versions in isolation before broader rollout.
  # - Gradually applying module updates across different environments.
  # - Utilizing a fork or customized version of a Terraform module for specific use cases.
  #
  # Configuration here is intentionally left flexible to accommodate various operational and development needs, ensuring
  # that module behavior can be tailored to match exact project requirements without altering global configurations.
  # ---------------------------------------------------------------------------------------------------------------------

  # `module_version_override` allows for the explicit specification of a module version, overriding the default version
  # specified in the global `_modules/<module>.hcl` files. This is particularly useful for testing or gradually
  # introducing changes. Leave this variable empty to adhere to the versioning specified in the module's global
  # configuration file. When set, this override affects only the current child configuration, allowing for precise,
  # scoped adjustments to module versioning without impacting the entire project.
  #
  # Example usage:
  # module_version_override = "v1.2.3"  # Specific version for testing or rollback purposes.
  # Leave as an empty string to use the default version from the global module configuration.
  module_version_override = ""
}
