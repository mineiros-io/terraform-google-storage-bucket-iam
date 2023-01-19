module "test-sa" {
  source = "github.com/mineiros-io/terraform-google-service-account?ref=v0.1.1"

  account_id = "service-account-id-${local.random_suffix}"
}

module "test" {
  source = "../.."

  # add all required arguments

  bucket = module.test-sa.service_account.id

  role = "roles/viewer"

  # add all optional arguments that create additional/extended resources

  members = [
    "user:member@example.com",
    "computed:myserviceaccount",
  ]
  computed_members_map = {
    myserviceaccount = "serviceAccount:${module.test-sa.service_account.email}"
  }

  condition = {
    title       = "allow after 2020"
    description = "allow access from 2020"
    expression  = "request.time.getFullYear() > 2020"
  }
  # add most/all other optional arguments
}

module "test2" {
  source = "../.."

  # add all required arguments

  bucket = module.test-sa.service_account.id

  role = "roles/viewer"

  # add all optional arguments that create additional/extended resources

  authoritative = false
  members = [
    "user:member@example.com",
    "computed:myserviceaccount",
  ]
  computed_members_map = {
    myserviceaccount = "serviceAccount:${module.test-sa.service_account.email}"
  }

  # add most/all other optional arguments
}

module "test3" {
  source = "../.."

  # add all required arguments

  bucket = module.test-sa.service_account.id

  policy_bindings = [
    {
      role = "roles/viewer"
      members = [
        "user:member@example.com",
        "computed:myserviceaccount",
      ]
    },
    {
      role = "roles/browser"
      members = [
        "user:member@example.com",
      ]
    }
  ]

  computed_members_map = {
    myserviceaccount = "serviceAccount:${module.test-sa.service_account.email}"
  }
  # add all optional arguments that create additional/extended resources

  # add most/all other optional arguments
}

module "test4" {
  source = "../.."

  # add all required arguments

  bucket = module.test-sa.service_account.id

  policy_bindings = [
    {
      role = "roles/viewer"
      members = [
        "user:member@example.com",
        "computed:myserviceaccount",
      ]
      condition = {
        expression = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
        title      = "expires_after_2021_12_31"
      }
    },
  ]

  computed_members_map = {
    myserviceaccount = "serviceAccount:${module.test-sa.service_account.email}"
  }
  # add all optional arguments that create additional/extended resources

  # add most/all other optional arguments
}
