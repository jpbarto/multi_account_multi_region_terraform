module "sandbox_account" {
  source = "modules/account"

  account_name = "sandbox"
  target_account_role_arn = "arn:aws:iam::776347453069:role/OrganizationAccountAccessRole"
}

module "dev_account" {
  source = "modules/account"

  account_name = "dev"
  target_account_role_arn = "arn:aws:iam::965078485732:role/OrganizationAccountAccessRole"
}