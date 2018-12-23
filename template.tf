module "config_rules" {
  source = "modules/config_rules"
  providers = {
      "aws" = "aws.frankfurt"
  }
}
