module "bucket" {
  source = "../"

  name = "example-bucket-e4c3"
}


# ╷
# │ Warning: Invalid Attribute Combination
# │
# │   with aws_s3_bucket_lifecycle_configuration.example,
# │   on main.tf line 26, in resource "aws_s3_bucket_lifecycle_configuration" "example":
# │   26:   rule {
# │
# │ No attribute specified when one (and only one) of [rule[0].prefix.<.filter] is required
# │
# │ This will be an error in a future version of the provider
# │
# │ (and one more similar warning elsewhere)

# resource "aws_s3_bucket_lifecycle_configuration" "example" {
#   bucket = module.bucket.bucket_id

#   rule {
#     id = "rule-1"

#     # ... other transition/expiration actions ...

#     status = "Enabled"
#   }
# }

# import {
#   to = aws_s3_bucket_lifecycle_configuration.rule_01
#   id = "spaghettimaghetti1"
# }

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


# module "bucket" {
#   source = "../"

#   name = "example-bucket-e4c3"
# }
# module "bucket_with_lifecycle" {
#   source = "../"

#   name = "example-bucket-4u3d"

#   #   REPLECATED ERROR:
#   #   ╷
#   # │ Warning: Invalid Attribute Combination
#   # │
#   # │   with module.bucket_with_lifecycle.aws_s3_bucket_lifecycle_configuration.lifecycle_rule["example-rule"],
#   # │   on ..\rule_lifcycle_example.tf line 10, in resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_rule":
#   # │   10:   rule {
#   # │
#   # │ 2 attributes specified when one (and only one) of
#   # │ [rule[0].filter[0].prefix.<.object_size_greater_than,rule[0].filter[0].prefix.<.object_size_less_than,rule[0].filter[0].prefix.<.and,rule[0].filter[0].prefix.<.tag] is required
#   # │
#   # │ This will be an error in a future version of the provider
#   lifecycle_rules = [
#     {
#       id     = "example-rule"
#       status = "Enabled"
#       filter = {
#         prefix = "example-prefix"
#         tag = {
#           key   = "example-key"
#           value = "example-value"
#         }
#       }
#       expiration = {
#         date = "2022-01-01"
#         days = 30
#       }
#       transition = [
#         {
#           days          = 60
#           storage_class = "GLACIER"
#         }
#       ]
#       noncurrent_version_expiration = {
#         noncurrent_days = 90
#       }
#       noncurrent_version_transition = [
#         {
#           storage_class   = "STANDARD_IA"
#           noncurrent_days = 120
#         }
#       ]
#       abort_incomplete_multipart_upload = {
#         days_after_initiation = 7
#       }
#     }
#   ]
# }


# # module "bucket" {
# #   source = "../"

# #   name = "example-bucket-e4c3"
# # }
