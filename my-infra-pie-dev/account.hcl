# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  account_number        = get_aws_account_id()
  my_account_number = 000000000000
}
