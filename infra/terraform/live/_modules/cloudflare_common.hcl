locals {
  # ---------------------------------------------------------------------------------------------------------------------
  # COMMON CONFIGURATION PER MODULE
  # In this file, you can group common configuration that's shared across
  # all the modules for a given provider, such as CloudFlare, AWS, etc.
  # ---------------------------------------------------------------------------------------------------------------------
  cloudflare_account_id = get_env("CLOUDFLARE_ACCOUNT_ID", "")
}
