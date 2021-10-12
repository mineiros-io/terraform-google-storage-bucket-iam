resource "google_storage_bucket_iam_binding" "binding" {
  count = var.module_enabled && var.policy_bindings == null && var.authoritative ? 1 : 0

  bucket  = var.bucket
  role    = var.role
  members = var.members

  depends_on = [var.module_depends_on]
}

resource "google_storage_bucket_iam_member" "member" {
  for_each = var.module_enabled && var.policy_bindings == null && var.authoritative == false ? var.members : []

  bucket = var.bucket
  role   = var.role
  member = each.value

  depends_on = [var.module_depends_on]
}

resource "google_storage_bucket_iam_policy" "policy" {
  count = var.module_enabled && var.policy_bindings != null ? 1 : 0

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

      dynamic "condition" {
        for_each = try([binding.value.condition], [])

        content {
          expression  = condition.value.expression
          title       = condition.value.title
          description = try(condition.value.description, null)
        }
      }
    }
  }
}
