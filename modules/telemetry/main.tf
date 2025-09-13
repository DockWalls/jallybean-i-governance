terraform {
  required_providers { google = { source = "hashicorp/google", version = "~> 7.2.0" } }
}

resource "google_bigquery_dataset" "gov_logs" {
  project                    = var.project_id
  dataset_id                 = var.dataset_id
  location                   = "US"
  delete_contents_on_destroy = false
}

resource "google_logging_project_sink" "to_bq" {
  name                   = "governance-worm-sink"
  project                = var.project_id
  destination            = "bigquery.googleapis.com/projects/${var.project_id}/datasets/${google_bigquery_dataset.gov_logs.dataset_id}"
  include_children       = true
  unique_writer_identity = true
  filter                 = "resource.type=build AND jsonPayload.event=rulebook_checks"
}