# Set common variables for the region. This should only be used for initializing the global state bucket
locals {
  service_name = basename(get_terragrunt_dir())
  aws_role  = "arn:aws:iam::180823894277:role/ec2roletest"
}
