# Creates an encryption key for events.

# Read in global terragrunt configuration
include {
  path = find_in_parent_folders()
}

# Pull in the module
terraform {
  source = "github.com/denesmartins/terraform-aws-kms//modules/kms-cmk"
}

# Pull in environment variables
locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  env_vars     = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  service_vars = read_terragrunt_config(find_in_parent_folders("service.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Construct the service-environment string
  service_environment = format("%s-%s", local.service_vars.locals.service_name, local.env_vars.locals.environment)
}

# Set up the inputs
inputs = {

  # Configure basic information
  alias       = format("%s-event-encryption-key", local.service_environment)
  description = format("Encryption key for event subscriptions for %s", local.service_environment)

  # Configure cryptography
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  key_usage                = "ENCRYPT_DECRYPT"

  # Set up the key policy
  key_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Allow IAM policies",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : format("arn:aws:iam::%s:root", local.account_vars.locals.account_number)
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
      {
        "Sid" : "Allow SNS to publish to SQS"
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "sns.amazonaws.com"
        },
        "Action" : [
          "kms:GenerateDataKey",
          "kms:Decrypt"
        ],
        "Resource" : "*"
      }
    ]
  })
}
