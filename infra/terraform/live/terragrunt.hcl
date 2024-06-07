locals {
  # ---------------------------------------------------------------------------------------------------------------------
  # STACK CONFIGURATION
  # Defines variables for stack management, leveraging the stack's relative path to organize and name stacks consistently.
  # `stack_name_path` derives the path relative to the include path, ensuring stack configuration is modular and reusable.
  # `stack_name` extracts the first segment of the path as the stack name, facilitating stack identification and management.
  # ---------------------------------------------------------------------------------------------------------------------
  stack_name_path = "${path_relative_to_include()}/"
  stack_name      = split("/", local.stack_name_path)[0]

  # ---------------------------------------------------------------------------------------------------------------------
  # GLOBAL CONFIGURATION
  # Reads global configuration files from the `_globals` directory. These configurations apply universally across all
  # Terragrunt modules, ensuring a consistent and centralized management of critical settings like backend, ownership,
  # and Terraform versioning.
  # ---------------------------------------------------------------------------------------------------------------------
  backend_cfg    = read_terragrunt_config(find_in_parent_folders("../../../_globals/backend.hcl"))
  ownership_cfg  = read_terragrunt_config(find_in_parent_folders("../../../_globals/ownership.hcl"))
  tf_version_cfg = read_terragrunt_config(find_in_parent_folders("../../../_globals/tf_version.hcl"))

  # ---------------------------------------------------------------------------------------------------------------------
  # HIERARCHICAL CONFIGURATION
  # Implements a layered configuration strategy, allowing for fine-grained control over Terragrunt's behavior and
  # Terraform's configuration at various levels (common, environment, stack, region). This approach promotes reuse and
  # simplifies configuration management across multiple dimensions (e.g., environments, regions).
  #
  #│           ├── terragrunt-stack
  #│           │   ├── <env>
  #│           │   │   ├── env.hcl (inherited)
  #│           │   │   ├── env.tfvars
  #│           │   │   └── global
  #│           │   │       ├── <module> E.g.: cloudflare-dns-zone
  #│           │   │       │   ├── module.hcl (inherited)
  #│           │   │       │   ├── terraform.tfvars
  #│           │   │       │   └── terragrunt.hcl
  #│           │   │       ├── <module> E.g.: cloudflare-zoho-email-dns-records
  #│           │   │       │   ├── module.hcl (inherited)
  #│           │   │       │   ├── terraform.tfvars
  #│           │   │       │   └── terragrunt.hcl
  #│           │   │       │   └── providers.hcl
  #│           │   │       ├── region.hcl (inherited)
  #│           │   │       └── region.tfvars
  #│           │   ├── stack.hcl (inherited)
  #│           │   └── stack.tfvars
  #│           └── terragrunt.hcl
  #
  # ---------------------------------------------------------------------------------------------------------------------
  providers_cfg   = read_terragrunt_config("${get_terragrunt_dir()}/providers.hcl")
  module_cfg      = read_terragrunt_config("${get_terragrunt_dir()}/module.hcl")
  common_cfg      = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  stack_cfg       = read_terragrunt_config(find_in_parent_folders("stack.hcl"))
  environment_cfg = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_cfg      = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # ---------------------------------------------------------------------------------------------------------------------
  # PROVIDER GLOBAL CONFIGURATION
  # Centralizes provider configuration to ensure consistent provider behavior across all modules. This configuration
  # is critical for managing provider-specific settings and credentials in a secure and reusable manner.
  # ---------------------------------------------------------------------------------------------------------------------
  providers_globals_cfg = read_terragrunt_config(find_in_parent_folders("../../../_providers/config.hcl"))

  # ---------------------------------------------------------------------------------------------------------------------
  # ENVIRONMENT AND REGION CONFIGURATION
  # Extracts environment and region settings from their respective configurations. These settings are pivotal for
  # deploying resources to the correct environment and region, aligning infrastructure deployment with organizational
  # policies and cloud provider best practices.
  # ---------------------------------------------------------------------------------------------------------------------
  environment = local.environment_cfg.locals.environment
  region      = local.region_cfg.locals.region

  # ---------------------------------------------------------------------------------------------------------------------
  # OWNERSHIP CONFIGURATION
  # Centralizes resource ownership tagging, facilitating resource management, cost allocation, and security auditing.
  # Allows for customization via the `_globals/ownership.hcl` file to meet specific organizational requirements.
  # ---------------------------------------------------------------------------------------------------------------------
  ownership_tags = local.ownership_cfg.locals.ownership_tags
  owner          = local.ownership_tags.owner
  layer          = local.ownership_tags.layer

  # ---------------------------------------------------------------------------------------------------------------------
  # REMOTE STATE CONFIGURATION
  # Manages state file configuration and settings, ensuring secure and consistent state management practices. This
  # configuration supports centralization, security features like encryption, and custom naming conventions for
  # state files, enhancing collaboration and operational efficiency.
  # ---------------------------------------------------------------------------------------------------------------------
  # Centralized remote state configuration settings derived from common configurations.
  remote_state_cfg = local.backend_cfg.locals

  # Detailed remote state configuration, providing enhanced readability and convenience for state management.
  module_name          = local.remote_state_cfg.tfstate_config.module_name
  tfstate_filename     = local.remote_state_cfg.tfstate_config.base_name
  backend_lock_table   = local.remote_state_cfg.aws_config.lock_table
  backend_state_bucket = local.remote_state_cfg.aws_config.state_bucket
  backend_region = local.remote_state_cfg.aws_config.region

  # Composes a structured key path for remote state files, aligning with organizational standards for resource naming.
  stack_name_with_prefix = can(regex("stack", local.stack_name)) ? local.stack_name : format("stack-%s", local.stack_name)
  remote_state_key_path = join("/", [
    local.owner,
    local.stack_name_with_prefix,
    local.layer,
    local.module_name,
    local.environment,
    local.region,
    local.tfstate_filename,
  ])
  # ---------------------------------------------------------------------------------------------------------------------
  # EXPOSED CONFIGURATION
  # These parameters are made visible for debugging and operational transparency, facilitating easier troubleshooting
  # and understanding of the active Terragrunt and Terraform configurations.
  # ---------------------------------------------------------------------------------------------------------------------
  # Each `run_cmd` invocation exports a configuration setting as an environment variable and outputs its value, aiding
  # in the visibility of critical parameters during runtime.
  expose_line_separator             = run_cmd("sh", "-c", "echo '================================================================================'")
  expose_stack_name                 = run_cmd("sh", "-c", format("export TERRAFORM_STACK_NAME=%s; echo Terragrunt Stack : $TERRAFORM_STACK_NAME", local.stack_name))
  expose_stack_name_path            = run_cmd("sh", "-c", format("export TERRAFORM_STACK_NAME_PATH=%s; echo Terragrunt Stack Path : $TERRAFORM_STACK_NAME_PATH", local.stack_name_path))
  expose_owner                      = run_cmd("sh", "-c", format("export OWNER=%s; echo Owner : $OWNER", local.owner))
  expose_layer                      = run_cmd("sh", "-c", format("export LAYER=%s; echo Layer : $LAYER", local.layer))
  expose_remote_state_key_path      = run_cmd("sh", "-c", format("export TERRAFORM_STATE_KEY_PATH=%s; echo Terraform state key path : $TERRAFORM_STATE_KEY_PATH", local.remote_state_key_path))
  expose_module_name                = run_cmd("sh", "-c", format("export MODULE_NAME=%s; echo Module Name : $MODULE_NAME", local.module_name))
  expose_environment                = run_cmd("sh", "-c", format("export ENVIRONMENT=%s; echo Environment : $ENVIRONMENT", local.environment))
  expose_region                     = run_cmd("sh", "-c", format("export REGION=%s; echo Region : $REGION", local.region))
  expose_terraform_version          = run_cmd("sh", "-c", format("export TERRAFORM_VERSION=%s; echo Terraform version : $TERRAFORM_VERSION", local.tf_version_cfg.locals.terraform_version))
  expose_terragrunt_version         = run_cmd("sh", "-c", format("export TERRAGRUNT_VERSION=%s; echo Terragrunt version : $TERRAGRUNT_VERSION", local.tf_version_cfg.locals.terragrunt_version))
  expose_terraform_state_bucket     = run_cmd("sh", "-c", format("export TERRAFORM_STATE_BUCKET=%s; echo Terraform state bucket : $TERRAFORM_STATE_BUCKET", local.backend_state_bucket))
  expose_terraform_state_lock_table = run_cmd("sh", "-c", format("export TERRAFORM_STATE_LOCK_TABLE=%s; echo Terraform state lock table : $TERRAFORM_STATE_LOCK_TABLE", local.backend_lock_table))
  expose_terraform_state_region     = run_cmd("sh", "-c", format("export TERRAFORM_STATE_REGION=%s; echo Terraform state region : $TERRAFORM_STATE_REGION", local.backend_region))
}

terraform {
  extra_arguments "optional_vars" {
    commands = [
      "apply",
      "destroy",
      "plan",
    ]

    required_var_files = [
      format("%s/terraform.tfvars", get_terragrunt_dir()),
      find_in_parent_folders("region.tfvars"),
      find_in_parent_folders("env.tfvars"),
      find_in_parent_folders("stack.tfvars"),
      find_in_parent_folders("common.tfvars"),
    ]

    optional_var_files = [
      format("%s/../../../globals-provider-%s-cloudflare.tfvars", get_terragrunt_dir(), local.environment),
      format("%s/../../../globals-provider-%s-aws.tfvars", get_terragrunt_dir(), local.environment),
    ]
  }

  extra_arguments "disable_input" {
    commands  = get_terraform_commands_that_need_input()
    arguments = ["-input=false"]
  }

  after_hook "clean_cache_after_apply" {
    commands = ["apply"]
    execute  = ["rm", "-rf", ".terragrunt-cache"]
  }

  after_hook "remove_auto_generated_backend" {
    commands = ["apply"]
    execute  = ["rm", "-rf", "backend.tf"]
  }

  after_hook "remove_auto_generated_provider" {
    commands = ["apply"]
    execute  = ["rm", "-rf", "provider.tf"]
  }
}


generate "terraform_version" {
  path              = ".terraform-version"
  if_exists         = "overwrite"
  disable_signature = true

  contents = <<EOF
    ${local.tf_version_cfg.locals.terraform_version}
  EOF
}

generate "terragrunt_version" {
  path              = ".terragrunt-version"
  if_exists         = "overwrite"
  disable_signature = true

  contents = <<EOF
    ${local.tf_version_cfg.locals.terragrunt_version}
  EOF
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = join("\n", concat(local.providers_cfg.locals.providers_content, local.providers_globals_cfg.locals.providers_content))
}

remote_state {
  disable_dependency_optimization = true
  backend  = lookup(local.remote_state_cfg.terragrunt_config, "backend", "s3")
  generate = lookup(local.remote_state_cfg.terragrunt_config, "generate", {
    path      = "backend.tf"
    if_exists = "overwrite"
  })

  config = {
    disable_bucket_update = lookup(local.remote_state_cfg.terragrunt_config, "disable_bucket_update", true)
    encrypt               = lookup(local.remote_state_cfg.terragrunt_config, "encrypt", true)

    s3_bucket_tags      = merge(local.remote_state_cfg.aws_config.s3_injected_tags_default, local.ownership_cfg.locals.ownership_tags)
    dynamodb_table_tags = merge(local.remote_state_cfg.aws_config.lock_table_injected_tags_default, local.ownership_cfg.locals.ownership_tags)

    region         = local.remote_state_cfg.aws_config.region
    dynamodb_table = local.remote_state_cfg.aws_config.lock_table
    bucket         = local.remote_state_cfg.aws_config.state_bucket

    key = local.remote_state_key_path
  }
}
