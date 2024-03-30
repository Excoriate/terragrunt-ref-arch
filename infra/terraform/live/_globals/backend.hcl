locals {
  # ---------------------------------------------------------------------------------------------------------------------
  # BACKEND COMMON CONFIGURATION
  # Centralizes configuration for Terraform's state management backend, specifically for AWS S3 in this context.
  # Defines key attributes like the backend type, state file generation behavior, and security features such as
  # encryption and bucket update prevention. This setup facilitates a consistent state management strategy across
  # Terragrunt modules, enhancing scalability and maintainability of infrastructure code.
  # ---------------------------------------------------------------------------------------------------------------------
  terragrunt_config = {
    backend  = "s3"  // Specifies AWS S3 as the backend for storing Terraform state files.
    generate = {
      path      = "backend.tf"  // Defines the generated Terraform configuration file for the backend.
      if_exists = "overwrite"  // Determines the behavior if the backend configuration file already exists.
    }
    disable_bucket_update = true
    // Prevents Terragrunt from attempting to modify the S3 bucket attributes after creation.
    encrypt               = true  // Ensures that the Terraform state files stored in S3 are encrypted at rest.
  }

  # ---------------------------------------------------------------------------------------------------------------------
  # REMOTE STATE AWS CONFIGURATION
  # Specifies configuration settings for AWS S3 as the remote state storage for Terraform modules. These settings
  # include the S3 bucket name, DynamoDB table for state locking, and default AWS region, sourced from environment
  # variables for flexibility and security. Additionally, default tags for the S3 bucket and DynamoDB table are defined
  # to support resource identification and organization.
  # ---------------------------------------------------------------------------------------------------------------------
  aws_config = {
    state_bucket             = get_env("TG_REMOTE_STATE_BUCKET")  // S3 bucket name for Terraform state files.
    lock_table               = get_env("TG_REMOTE_STATE_LOCK_TABLE")  // DynamoDB table for state locking.
    region                   = get_env("TG_REMOTE_STATE_REGION", "us-east-1")  // Default AWS region for the backend.
    // Optional configuration for skipping region validation, if necessary.
    // skip_region_validation   = get_env("TG_REMOTE_STATE_SKIP_REGION_VALIDATION", true)
    // Default tags for S3 bucket and DynamoDB table, enhancing resource management and compliance.
    s3_injected_tags_default = {
      name = "terraform-tfstate-bucket"
    }
    lock_table_injected_tags_default = {
      name = "terraform-tfstate-lock-table"
    }
  }

  tfstate_config = {
    // Recommends a naming convention for the module part of the state path that is stable and based on the file structure.
    // This approach minimizes reliance on volatile values and environment variables, promoting consistent state management.
    module_name = basename("${get_original_terragrunt_dir()}")  // Derives module name from the directory structure.
    base_name   = "terraform.tfstate"  // Default filename for the Terraform state file.
    // Fields `owner` and `layer` are designed to be merged with this configuration in the root `terragrunt.hcl` file,
    // supporting a comprehensive and customizable state path structure.
  }
}
