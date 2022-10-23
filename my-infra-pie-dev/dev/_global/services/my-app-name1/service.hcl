# Set common variables for the region. This should only be used for initializing the global state bucket
locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  service_name = basename(get_terragrunt_dir())
  aws_role  = format("arn:aws:iam::%s:role/ec2roletest", local.account_vars.locals.account_number)
}
