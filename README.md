# Terragrunt Reference Architecture 🌐

Welcome to the Terragrunt Reference Architecture repository! This project serves as a blueprint for creating and managing highly scalable, modular, and maintainable infrastructure as code (IaC) using Terragrunt and Terraform.

## Overview 📖

This repository embodies a structured approach to organizing Terraform code with Terragrunt, focusing on reusability, ease of management, and scalability across multiple environments and cloud providers. It's crafted to guide teams in building robust cloud infrastructure that adheres to best practices and principles.

## Structure 🏗️

```txt
├── infra
│   └── terraform
│       ├── live
│       │   ├── _globals
│       │   │   ├── backend.hcl
│       │   │   ├── git.hcl
│       │   │   ├── ownership.hcl
│       │   │   ├── tags.hcl
│       │   │   └── tf_version.hcl
│       │   ├── _modules
│       │   │   ├── cloudflare_common.hcl
│       │   │   ├── cloudflare_dns_zone.hcl
│       │   │   └── random_string.hcl
│       │   ├── _providers
│       │   │   └── config.hcl
│       │   ├── common.hcl
│       │   ├── common.tfvars
│       │   ├── stack-example
│       │   │   ├── prod
│       │   │   │   ├── env.hcl
│       │   │   │   ├── env.tfvars
│       │   │   │   └── global
│       │   │   │       ├── cloudflare-dns-zone
│       │   │   │       │   ├── .terraform.lock.hcl
│       │   │   │       │   ├── module.hcl
│       │   │   │       │   ├── terraform.tfvars
│       │   │   │       │   └── terragrunt.hcl
│       │   │   │       ├── random-string
│       │   │   │       │   ├── .terraform-version
│       │   │   │       │   ├── .terraform.lock.hcl
│       │   │   │       │   ├── .terragrunt-version
│       │   │   │       │   ├── module.hcl
│       │   │   │       │   ├── terraform.tfvars
│       │   │   │       │   └── terragrunt.hcl
│       │   │   │       ├── region.hcl
│       │   │   │       └── region.tfvars
│       │   │   ├── stack.hcl
│       │   │   └── stack.tfvars
│       │   └── terragrunt.hcl
│       ├── modules
│       │   └── random-string
│       │       ├── data.tf
│       │       ├── locals.tf
│       │       ├── main.tf
│       │       ├── outputs.tf
│       │       ├── variables.tf
│       │       └── versions.tf
│       ├── providers.aws.tpl
│       └── providers.cloudflare.tpl
```

The architecture is segmented into distinct sections, each serving a specific purpose within the Terragrunt framework:

- `_globals`: Centralized configurations for backend, ownership, versioning, and common tags.
- `_modules`: Modular configurations for provider-specific settings, promoting DRY principles.
- `_providers`: Provider configurations ensuring consistent behavior across modules.
- `stack-example`: An example stack demonstrating the application of this architecture across different environments and regions.

Each component is meticulously designed to fit into a hierarchical configuration strategy, facilitating fine-grained control and reuse across your infrastructure projects.

## Key Features 🔑

- **Modularity**: Break down your infrastructure into manageable, reusable components.
- **Scalability**: Easily adapt and scale your infrastructure to meet evolving requirements.
- **Best Practices**: Incorporates Terragrunt and Terraform best practices for security, state management, and infrastructure as code.

## Getting Started 🚀

To get started with this reference architecture:

1. Clone the repository to your local machine.
2. Navigate through the directories to understand the structure and purpose of each section.
3. Customize the configurations (_globals, _modules, _providers) according to your project's needs.
4. Use the `stack-example` as a template to create your own stacks.

This repository includes a [Taskfile](https://taskfile.dev) to simplify common tasks. Run `task` to see the available commands, or run a CI/Plan/Apply/Destroy on a given stack and module. E.g.:

```bash
task infra-ci tgmod=random-string env=prod stack=stack-example
```

## Documentation 📚

For more details on how to use Terragrunt and Terraform effectively within this architecture:

- [Terragrunt Documentation](https://terragrunt.gruntwork.io/docs/)
- [Terraform Documentation](https://www.terraform.io/docs/)


>**NOTE**: Each layer of this architecture has its own README file with detailed explanations and examples.

## Contributing 🤝

Contributions are welcome! If you have improvements or fixes, please open a pull request. For major changes or new features, please open an issue first to discuss what you would like to change.

## License 📄

This project is licensed under the MIT License - see the LICENSE file for details.

---

Embrace the power of Infrastructure as Code with this Terragrunt Reference Architecture and elevate your cloud infrastructure to new heights!
