locals {
  create_lifecycle_configuration = length(var.lifecycle_rules) > 0 ? { "${var.name}" = aws_s3_bucket.example.id } : {}
}

resource "aws_s3_bucket_lifecycle_configuration" "configuration" {

  for_each = local.create_lifecycle_configuration

  bucket = each.value

  dynamic "rule" {

    for_each = { for r in var.lifecycle_rules : r.id => r }

    content {
      id     = rule.value.id
      status = rule.value.status

      # When filter is empty provide default prefix of root "/" and empty tag
      dynamic "filter" {
        for_each = rule.value.filter == null ? [{
          prefix = "/"
        }] : []
        content {
          prefix = filter.value.prefix
        }
      }

      # Scenario where filter block has filter.prefix
      dynamic "filter" {
        for_each = (rule.value.filter != null && try(rule.value.filter.prefix, null) != null) ? [rule.value.filter] : []
        content {
          prefix = filter.value.prefix
        }
      }

      # Scenario where filter block has filter.tag
      dynamic "filter" {
        for_each = (rule.value.filter != null && try(rule.value.filter.tag, null) != null) ? [rule.value.filter] : []
        content {
        # TODO: TEST if prefix is required in this scenario
        #   prefix = filter.value.prefix

          dynamic "tag" {
            for_each = filter.value.tag != null ? [filter.value.tag] : []

            content {
              key   = tag.value.key
              value = tag.value.value
            }
          }
        }
      }

      # Scenario where filter block has filter.and
      dynamic "filter" {
        for_each = (rule.value.filter != null && try(rule.value.filter.and, null) != null) ? [rule.value.filter] : []

        content {
          dynamic "and" {

            for_each = filter.value.and != null ? [filter.value.and] : []

            content {
              prefix                   = and.value.prefix != null ? and.value.prefix : null
              tags                     = and.value.tags != null ? and.value.tags : null
              object_size_greater_than = and.value.object_size_greater_than != null ? and.value.object_size_greater_than : null
              object_size_less_than    = and.value.object_size_less_than != null ? and.value.object_size_less_than : null
            }
          }
        }
      }


      #   Combined filter block
      #   dynamic "filter" {
      #     for_each = rule.value.filter == null ? [{ prefix = "/", and = null }] : [{ prefix = rule.value.filter.prefix, and = rule.value.filter.and }]
      #     content {
      #       prefix = filter.value.prefix

      #       dynamic "and" {
      #         for_each = filter.value.and != null ? [filter.value.and] : []
      #         content {
      #           prefix                   = and.value.prefix
      #           tags                     = and.value.tags
      #           object_size_greater_than = and.value.object_size_greater_than
      #           object_size_less_than    = and.value.object_size_less_than
      #         }
      #       }
      #     }
      #   }

      # Add other dynamic blocks for expiration, transition, etc., here as needed

      # Expiration block
      dynamic "expiration" {
        for_each = rule.value.expiration != null ? [rule.value.expiration] : []
        content {
          date = expiration.value.date
          days = expiration.value.days
          # delete_marker = expiration.value.delete_marker
        }
      }

      # Transition block
      dynamic "transition" {
        for_each = rule.value.transition != null ? rule.value.transition : []
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      # Noncurrent Version Expiration block
      dynamic "noncurrent_version_expiration" {
        for_each = rule.value.noncurrent_version_expiration != null ? [rule.value.noncurrent_version_expiration] : []
        content {
          noncurrent_days = noncurrent_version_expiration.value.noncurrent_days
        }
      }

      # Noncurrent Version Transition block
      dynamic "noncurrent_version_transition" {
        for_each = rule.value.noncurrent_version_transition != null ? rule.value.noncurrent_version_transition : []
        content {
          storage_class   = noncurrent_version_transition.value.storage_class
          noncurrent_days = noncurrent_version_transition.value.noncurrent_days
        }
      }

      # Abort Incomplete Multipart Upload block
      dynamic "abort_incomplete_multipart_upload" {
        for_each = rule.value.abort_incomplete_multipart_upload != null ? [rule.value.abort_incomplete_multipart_upload] : []
        content {
          days_after_initiation = abort_incomplete_multipart_upload.value.days_after_initiation
        }
      }
    }
  }
}
