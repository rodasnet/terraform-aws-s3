variable "lifecycle_rules" {
  type = list(object({
    id     = string            # Required: Unique identifier for the rule (max 255 characters)
    status = string            # Required: Whether the rule is Enabled or Disabled
    filter = optional(object({ # Optional: Used to identify objects the rule applies to
      prefix = optional(string)
      tag = optional(object({
        key   = string
        value = string
      }))
      object_size_greater_than = optional(map(any))
      object_size_less_than    = optional(map(any))
      and = optional(object({
        prefix = optional(string)
      tags = optional(map(any)) }))
    }))
    expiration = optional(object({     # Optional: Specifies expiration configuration
      date          = optional(string) # Expiration date in ISO 8601 format
      days          = optional(number) # Expiration in days
      delete_marker = optional(bool)   # Whether to expire delete markers
    }))
    transition = optional(list(object({ # Optional: Specifies transition configuration
      days          = optional(number)  # Transition after days
      storage_class = string            # Target storage class (e.g., GLACIER, STANDARD_IA)
    })))
    noncurrent_version_expiration = optional(object({ # Optional: Expiration for noncurrent object versions
      noncurrent_days = number                        # Number of days after which noncurrent versions expire
    }))
    noncurrent_version_transition = optional(list(object({ # Optional: Transition for noncurrent object versions
      storage_class   = string                             # Target storage class
      noncurrent_days = number                             # Number of days after which to transition
    })))
    abort_incomplete_multipart_upload = optional(object({ # Optional: Cleanup for incomplete multipart uploads
      days_after_initiation = number                      # Days since initiation to abort incomplete uploads
    }))
  }))
  default = []

  # validation {
  #   condition = alltrue([
  #     for rule in var.lifecycle_rules : (
  #       rule == null || (length(compact([
  #         try((rule.filter.prefix != null), null),
  #         try((rule.filter.tag != null), null),
  #         try((rule.filter.object_size_greater_than != null), null),
  #         try((rule.filter.object_size_less_than != null), null),
  #         try((rule.filter.and != null), null)
  #         ])) < 2
  #       )
  #     )
  #   ])
  #   error_message = "Each filter block must either be empty or have exactly one of 'prefix', 'tag', 'object_size_greater_than', 'object_size_less_than', or 'and' specified."
  # }
}

variable "name" {
  type = string

}
