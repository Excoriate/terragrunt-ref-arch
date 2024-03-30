# `_globals` Directory Overview

The `_globals` directory is a key part of our Terragrunt reference architecture, designed to encapsulate configurations that are common across multiple modules and environments. This approach promotes the DRY (Don't Repeat Yourself) principle, ensuring consistency and facilitating easier management and updates across our infrastructure codebase.

## Structure

The directory consists of the following files, each serving a specific purpose within our global configuration strategy:


```txt
_globals/
├── backend.hcl
├── git.hcl
├── ownership.hcl
├── tags.hcl
└── tf_version.hcl
```


## Configuration Files

### `backend.hcl`

- **Purpose**: Configures Terraform's state management backend, typically AWS S3, including encryption and bucket update prevention.
- **Key Features**: Backend type specification, state file generation behavior, security features.
- **Usage**: Included in the root `terragrunt.hcl` to ensure a consistent state management strategy.

### `git.hcl`

- **Purpose**: Provides centralized Git configuration for module sourcing, specifying the base URL for Git repositories.
- **Key Features**: Base URL configuration, preference for SSH authentication.
- **Usage**: Facilitates module sourcing and version management across the project.

### `ownership.hcl`

- **Purpose**: Defines resource ownership and organizational structuring, aiding in resource tagging and management.
- **Key Features**: Dynamic environment variable support, ownership tagging.
- **Usage**: Helps associate resources with specific owners and infrastructure layers.

### `tags.hcl`

- **Purpose**: Establishes a set of global tags applicable to all resources, supporting identification, organization, and governance.
- **Key Features**: ManagedBy, OrchestratedBy, Author, and Owner tags.
- **Usage**: Applied to resources in Terraform `resource` blocks for unified tagging.

### `tf_version.hcl`

- **Purpose**: Specifies required Terraform and Terragrunt versions, ensuring consistent tooling across environments.
- **Key Features**: Version specification and overrides via environment variables.
- **Usage**: Ensures that the infrastructure is provisioned using approved tooling versions.

## Importance of `_globals`

The `_globals` directory underpins our commitment to efficient, maintainable infrastructure code by reducing redundancy, simplifying updates, and ensuring consistency across all modules and environments. It represents the foundational settings of our infrastructure, embodying key principles such as IaC (Infrastructure as Code) and the DRY principle.

For a deeper dive into best practices and detailed documentation, visit the [Terragrunt Documentation](https://terragrunt.gruntwork.io/docs/).
