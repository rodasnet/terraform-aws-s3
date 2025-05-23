resource random_string "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "bucket" {
  bucket = "expiration-${random_string.bucket_suffix.result}"
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket-config" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    id = "log"

    expiration {
      days = 90
    }

    filter {
      and {
        prefix = "log/"

        tags = {
          rule      = "log"
          autoclean = "true"
        }
      }
    }

    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }

  rule {
    id = "tmp"

    filter {
      prefix = "tmp/"
    }

    expiration {
      # date = "2026-01-13T00:00:00Z"
      # date = formatdate("YYYY-MM-DD",  "2027-01-13T")
      # date = formatdate("YYYY-MM-DDT00:00:00Z", "2026-01-13")

      # date = "${"2026-01-13"}T00:00:00Z"
      date = local.formatted_date
      # date = "2026-01-13"
    }

    status = "Enabled"
  }
}

resource random_string "bucket_suffix-2" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "versioning_bucket" {
  bucket = "noexpiration-${random_string.bucket_suffix-2.result}"
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

    noncurrent_version_expiration {
      noncurrent_days = 90
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