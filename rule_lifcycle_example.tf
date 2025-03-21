resource "aws_s3_bucket" "example" {
  bucket = var.name
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_rule" {
  for_each = { for rule in var.lifecycle_rules : rule.id => rule }

  bucket = aws_s3_bucket.example.id

  rule {
    id     = each.value.id
    status = each.value.status

    dynamic "filter" {
      for_each = each.value.filter != null && (
        each.value.filter.prefix != null ||
        each.value.filter.tag != null ||
        each.value.filter.object_size_greater_than != null ||
        each.value.filter.object_size_less_than != null
      ) ? [each.value.filter] : []

      content {
        prefix = filter.value.prefix

        dynamic "tag" {
          for_each = filter.value.tag != null ? [filter.value.tag] : []
          content {
            key   = tag.value.key
            value = tag.value.value
          }
        }
      }
    }

    # Filter block Copilot example
    # dynamic "filter" {
    #   for_each = each.value.filter != null && (
    #     each.value.filter.prefix != null ||
    #     each.value.filter.tag != null ||
    #     each.value.filter.object_size_greater_than != null ||
    #     each.value.filter.object_size_less_than != null
    #   ) ? [each.value.filter] : []

    #   content {
    #     prefix = filter.value.prefix

    #     dynamic "tag" {
    #       for_each = filter.value.tag != null ? [filter.value.tag] : []
    #       content {
    #         key   = tag.value.key
    #         value = tag.value.value
    #       }
    #     }
    #   }
    # }

    # Filter block simple example
    # dynamic "filter" {
    #   for_each = each.value.filter != null ? [each.value.filter] : []
    #   content {
    #     prefix = filter.value.prefix

    #     dynamic "tag" {
    #       for_each = filter.value.tag != null ? [filter.value.tag] : []

    #       content {
    #         key   = tag.key
    #         value = tag.value
    #       }

    #     }
    #   }
    # }

    # Expiration block
    dynamic "expiration" {
      for_each = each.value.expiration != null ? [each.value.expiration] : []
      content {
        date = expiration.value.date
        days = expiration.value.days
        # delete_marker = expiration.value.delete_marker
      }
    }

    # Transition block
    dynamic "transition" {
      for_each = each.value.transition != null ? each.value.transition : []
      content {
        days          = transition.value.days
        storage_class = transition.value.storage_class
      }
    }

    # Noncurrent Version Expiration block
    dynamic "noncurrent_version_expiration" {
      for_each = each.value.noncurrent_version_expiration != null ? [each.value.noncurrent_version_expiration] : []
      content {
        noncurrent_days = noncurrent_version_expiration.value.noncurrent_days
      }
    }

    # Noncurrent Version Transition block
    dynamic "noncurrent_version_transition" {
      for_each = each.value.noncurrent_version_transition != null ? each.value.noncurrent_version_transition : []
      content {
        storage_class   = noncurrent_version_transition.value.storage_class
        noncurrent_days = noncurrent_version_transition.value.noncurrent_days
      }
    }

    # Abort Incomplete Multipart Upload block
    dynamic "abort_incomplete_multipart_upload" {
      for_each = each.value.abort_incomplete_multipart_upload != null ? [each.value.abort_incomplete_multipart_upload] : []
      content {
        days_after_initiation = abort_incomplete_multipart_upload.value.days_after_initiation
      }
    }
  }
}
