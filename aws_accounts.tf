module "sandbox_account" {
  source = "modules/account"

  account_name = "sandbox"
  target_account_role_arn = "arn:aws:iam::0123456789019:role/OrganizationAccountAccessRole"
}

module "dev_account" {
  source = "modules/account"

  account_name = "dev"
  target_account_role_arn = "arn:aws:iam::012345678912:role/OrganizationAccountAccessRole"
}
