include "root" {
  path           = find_in_parent_folders()
  merge_strategy = "deep"
}

include "git_globals" {
  path           = "${get_terragrunt_dir()}/../../../../_globals/git.hcl"
  expose         = true
  merge_strategy = "deep"
}

include "module" {
  path           = "${get_terragrunt_dir()}/../../../../_modules/cloudflare_dns_zone.hcl"
  expose         = true
  merge_strategy = "deep"
}

locals {
  tags           = include.module.locals.tags
  base_url       = include.git_globals.locals.github_base_url
  module_version = include.module.locals.tf_module_version
}

terraform {
  source = format("%s/Excoriate/terraform-cloudflare-modules.git//modules/cloudflare-zone?ref=%s", local.base_url, local.module_version)
}


inputs = {
}
