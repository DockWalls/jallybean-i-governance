terraform {
  required_providers {
    google = { source = "hashicorp/google", version = "~> 7.2.0" }
  }
}

resource "google_project_iam_binding" "role_bindings" {
  for_each = var.principals
  project  = var.project_id
  role     = each.key
  members  = each.value
}