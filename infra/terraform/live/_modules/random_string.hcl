locals {
  # ---------------------------------------------------------------------------------------------------------------------
  # STACK CONFIGURATION
  # This section is used to configure the module with attributes that are specific to the stack.
  # The 'stack.hcl' file contains the configuration for the stack.
  # ---------------------------------------------------------------------------------------------------------------------
  stack_cfg  = read_terragrunt_config(find_in_parent_folders("stack.hcl"))
  module_cfg = read_terragrunt_config("${get_terragrunt_dir()}/module.hcl")

  # ---------------------------------------------------------------------------------------------------------------------
  # GIT MODULE CONFIGURATION
  # This section is used to configure the git module. This module is used to clone the git repository and checkout the
  # the specific 'terraform' module version.
  # ---------------------------------------------------------------------------------------------------------------------
  tf_module_version_default = "v0.1.4"
  tf_module_version         = lookup(local.module_cfg.locals == null ? {} : local.module_cfg.locals, "module_version_override", local.tf_module_version_default)

  # ---------------------------------------------------------------------------------------------------------------------
  # CLOUDFLARE CONFIGURATION
  # This section is used to configure the cloudflare module. This module is used to create the cloudflare resources.
  # All the 'common' configuration regarding this provider is encapsulated in the 'cloudflare_common.hcl' file.
  # ---------------------------------------------------------------------------------------------------------------------
  cloudflare_cfg = read_terragrunt_config("${get_terragrunt_dir()}/../../../../_modules/cloudflare_common.hcl")

  # ---------------------------------------------------------------------------------------------------------------------
  # TAGS
  # These tags are a mix of global tags and stack specific tags, including 'ownership' tags
  # That are defined in the '_globals/ownership.hcl' file.
  # These tags are referenced in the child terragrunt configurations, and from there they can be merged
  # with specific tags for each resource.
  # ---------------------------------------------------------------------------------------------------------------------
  global_tags_cfg = read_terragrunt_config("${get_terragrunt_dir()}/../../../../_globals/tags.hcl")
  ownership_cfg   = read_terragrunt_config("${get_terragrunt_dir()}/../../../../_globals/ownership.hcl")
  global_tags     = local.global_tags_cfg.locals.global_tags
  ownership_tags  = local.ownership_cfg.locals.ownership_tags

  # Reference this in the terragrunt configuration file (child configuration)
  tags = merge(local.global_tags, local.ownership_tags)
}


inputs = {
}
