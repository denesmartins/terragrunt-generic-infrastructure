# Creates a role for the service.

# Read in global terragrunt configuration
include {
  path = find_in_parent_folders()
}

# Pull in the terraform module
terraform {
  source = "git@github.com:denesmartins/terraform-terraform-aws-iam.git//modules/iam-role"
}

# Pull in environment variables
locals {
  env_vars     = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  service_vars = read_terragrunt_config(find_in_parent_folders("service.hcl"))
}

# Set up the inputs
inputs = {
  role_name = format("%s-%s", local.service_vars.locals.service_name, local.env_vars.locals.environment)
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "AWS" : local.service_vars.locals.aws_role
        }
      }
    ]
  })
}
