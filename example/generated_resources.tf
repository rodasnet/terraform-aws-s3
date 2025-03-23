# # __generated__ by Terraform
# # Please review these resources and move them into your main configuration files.

# # __generated__ by Terraform from "spaghettimaghetti1"
resource "aws_s3_bucket_lifecycle_configuration" "rule_01" {
  bucket                                 = "spaghettimaghetti1"
  expected_bucket_owner                  = null
  transition_default_minimum_object_size = "all_storage_classes_128K"
  rule {
    id     = "rule_02"
    status = "Enabled"

    # Minimum configuration for a rule
    filter {
      prefix = "/"
    }

    # at least one of the following is required
    abort_incomplete_multipart_upload {
      days_after_initiation = 1
    }
    # expiration {
    #   date = null
    #   days = 1
    #   # expired_object_delete_marker = false
    # }

    # noncurrent_version_expiration {
    #   newer_noncurrent_versions = null
    #   noncurrent_days           = 1
    # }

  }
}
# resource "aws_s3_bucket_lifecycle_configuration" "rule_01" {
#   bucket                                 = "spaghettimaghetti1"
#   expected_bucket_owner                  = null
#   transition_default_minimum_object_size = "all_storage_classes_128K"
#   rule {
#     id     = "rule_01"
#     status = "Enabled"
#     abort_incomplete_multipart_upload {
#       days_after_initiation = 1
#     }
#     expiration {
#       date                         = null
#       days                         = 1
#       # expired_object_delete_marker = false
#     }
#     filter {
#       object_size_greater_than = null
#       object_size_less_than    = null
#       prefix                   = "/"
#     }
#     noncurrent_version_expiration {
#       newer_noncurrent_versions = null
#       noncurrent_days           = 1
#     }
#   }
# }
