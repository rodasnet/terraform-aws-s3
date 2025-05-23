/*
module "bucket" {
  source = "../"

  name = "bucket-lifecycle-none-e4c3"
}

module "bucket_with_lifecycle_default" {
  source = "../"

  name = "bucket-lifecycle-default-4u3d"

  lifecycle_rules = [
    {
      id     = "rule-default-4u3d"
      status = "Enabled"

      abort_incomplete_multipart_upload = {
        days_after_initiation = 6
      }
    }
  ]
}

module "bucket_with_lifecycle_prefix" {
  source = "../"

  name = "bucket-lifecycle-prefix-3939"

  lifecycle_rules = [
    {
      id     = "rule-prefix-3939"
      status = "Enabled"
      filter = {
        prefix = "/"
      }
      abort_incomplete_multipart_upload = {
        days_after_initiation = 8
      }
    }
  ]
}


module "bucket_with_lifecycle_tag" {
  source = "../"

  name = "bucket-lifecycle-tag-09ik"

  lifecycle_rules = [
    {
      id     = "rule-tag-09ik"
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

module "bucket_with_lifecycle_and" {
  source = "../"

  name = "bucket-lifecycle-and-ba04"

  lifecycle_rules = [
    {
      id     = "rule-and-ba04"
      status = "Enabled"
      filter = {
        and = {
          prefix = "log/"
          tags = {
            Key1 = "Value1"
            Key2 = "Value2"
          }
        }
      }
      expiration = {
        # TODO: Fix date input format
        # date = "2023-01-13T00:00:00Z"
        days = 30
      }
    },
    {
      id     = "rule-and-ba05"
      status = "Enabled"
      filter = {
        and = {
          tags = {
            Key1 = "Value1"
            Key2 = "Value2"
          }
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

# TODO: TEST lifecycle_rules with filter.objsize
module "bucket_with_lifecycle_objsize" {
  source = "../"

  name = "bucket-lifecycle-objsize1"

  lifecycle_rules = [
    {
      id     = "rule-objsize1"
      status = "Enabled"
      filter = {
        object_size_greater_than = 1
      }
      transition = [{
        days          = 365
        storage_class = "GLACIER_IR"
      }]
    }
  ]
}

resource "aws_s3_bucket" "versioning_bucket" {
  bucket = "8383-versioning-bucket"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.versioning_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "versioning-bucket-config" {
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.versioning]

  bucket = aws_s3_bucket.versioning_bucket.id

  rule {
    id = "config"

    filter {
      prefix = "config/"
    }

    # noncurrent_version_expiration {
    #   noncurrent_days = 90
    # }

    noncurrent_version_expiration {
      noncurrent_days = 180
      newer_noncurrent_versions = 1
    }

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = 60
      storage_class   = "GLACIER"
    }

    status = "Enabled"
  }
}

*/

