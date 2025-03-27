module "bucket" {
  source = "../"

  name = "example-bucket-e4c3"
}

module "bucket_with_lifecycle_minimal" {
  source = "../"

  name = "example-bucket-4u3d"

  lifecycle_rules = [
    {
      id     = "example-rule-4u3d"
      status = "Enabled"

      abort_incomplete_multipart_upload = {
        days_after_initiation = 6
      }
    }
  ]
}

module "bucket_with_lifecycle_prefix" {
  source = "../"

  name = "example-bucket-prefix-3939"

  lifecycle_rules = [
    {
      id     = "example-rule-3939"
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

# TODO: TEST lifecycle_rules with filter.and
# module "bucket_with_lifecycle_filter_and" {
#   source = "../"

#   name = "example-bucket-filterand1"

#   lifecycle_rules = [
#     {
#       id     = "rule-andbolck1"
#       status = "Enabled"
#       filter = {
#         and = {
#           prefix = "log/"
#           tags = {
#             Key1 = "Value1"
#             Key2 = "Value2"
#           }
#         }
#       }
#       expiration = {
#         # TODO: Fix date input format
#         # date = "2023-01-13T00:00:00Z"
#         days = 30
#       }
#     }
#   ]
# }

# module "bucket_with_lifecycle_vialation_tag_and_prefix" {
#   source = "../"

#   name = "example-bucket-tag-prefix-3j3j"

#   lifecycle_rules = [
#     {
#       id     = "example-rule-00"
#       status = "Enabled"
#       filter = {
#         tag = {
#           key   = "example-key"
#           value = "example-value"
#         }
#         prefix = "/"
#       }
#       abort_incomplete_multipart_upload = {
#         days_after_initiation = 7
#       }
#     }
#   ]
# }

# module "bucket_with_lifecycle_objsize" {
#   source = "../"

#   name = "example-bucket-objsize1"

#   lifecycle_rules = [
#     {
#       id     = "example-rule-00"
#       status = "Enabled"
#       filter = {
#         object_size_greater_than = 1
#       }
#       transition = [{
#         days          = 365
#         storage_class = "GLACIER_IR"
#       }]
#     }
#   ]
# }
