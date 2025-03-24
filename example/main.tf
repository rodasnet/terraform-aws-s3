module "bucket" {
  source = "../"

  name = "example-bucket-e4c3"
}

module "bucket_with_lifecycle_minimal" {
  source = "../"

  name = "example-bucket-4u3d"

  lifecycle_rules = [
    {
      id     = "example-rule-00"
      status = "Enabled"

      abort_incomplete_multipart_upload = {
        days_after_initiation = 7
      }
    }
  ]
}

module "bucket_with_lifecycle_09ik" {
  source = "../"

  name = "example-bucket-09ik"

  lifecycle_rules = [
    {
      id     = "rule-09ik"
      status = "Enabled"
      filter = {
        tag = {
          key   = "example-key"
          value = "example-value"
        }
      }
      expiration = {
        # TODO: Fix date input format
        # date = "2023-01-13T00:00:00Z"
        days = 30
      }
    }
  ]
}
