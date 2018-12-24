module "sandbox_account" {
  source = "modules/account"

    target_account_arn = "arn:aws:iam::776347453069:role/OrganizationAccountAccessRole"
}