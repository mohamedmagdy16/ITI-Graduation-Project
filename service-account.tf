#service account with kubernetes engin admin rule for private vm 
#which needed for kubectl configuration

resource "google_service_account" "service_account" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}

resource "google_project_iam_member" "vm_sa" {
  project = var.project_id
  role    ="roles/container.admin"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

