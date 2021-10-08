resource "google_storage_bucket_iam_binding" "binding" {
  count = var.module_enabled && var.policy_bindings == null && var.authoritative ? 1 : 0

  project = var.project
  bucket  = var.bucket
  role    = var.role
  members = var.members

  depends_on = [var.module_depends_on]
}

resource "google_storage_bucket_iam_member" "member" {
  for_each = var.module_enabled && var.policy_bindings == null && var.authoritative == false ? var.members : []

  project = var.project
  bucket  = var.bucket
  role    = var.role
  member  = each.value

  depends_on = [var.module_depends_on]
}

resource "google_storage_bucket_iam_policy" "policy" {
  count = var.module_enabled && var.policy_bindings != null ? 1 : 0

  project     = var.project
  bucket      = var.bucket
  policy_data = data.google_iam_policy.policy[0].policy_data

  depends_on = [var.module_depends_on]
}

data "google_iam_policy" "policy" {
  count = var.module_enabled && var.policy_bindings != null ? 1 : 0

  dynamic "binding" {
    for_each = var.policy_bindings

    content {
      role    = binding.value.role
      members = try(binding.value.members, var.members)

      condition {
        expression  = binding.value.condition.expression
        title       = binding.value.condition.title
        description = try(binding.value.condition.description, null)
      }
    }
  }
}
