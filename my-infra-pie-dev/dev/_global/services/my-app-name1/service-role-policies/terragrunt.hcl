# Attaches policies to the service role.

# Add a dependency on the service role
dependency "service_role" {
  config_path = "../service-role"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs_merge_with_state           = true
  mock_outputs = {
    role_name = "mock-role-name"
  }
}

# Read in global terragrunt configuration
include {
  path = find_in_parent_folders()
}

# Pull in the terraform module
terraform {
  source = "git@github.com:denesmartins/terraform-terraform-aws-iam.git//modules/attach-policy-to-role"
}

# Set up the attachments
inputs = {
  role_name = dependency.service_role.outputs.role_name
  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
  ]
}
