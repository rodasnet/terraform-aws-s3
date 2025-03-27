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
      object_size_greater_than = optional(number)
      object_size_less_than    = optional(number)
      and = optional(object({
        prefix                   = optional(string)
        tags                     = optional(map(string))
        object_size_greater_than = optional(number)
        object_size_less_than    = optional(number)
      }))
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

  validation {
    condition = alltrue([
      for rule in var.lifecycle_rules : (
        # rule == null || rule.filter.prefix == null ||
        # rule == null || (rule.filter != null && rule.filter.prefix == null) ||
        # rule == null || rule.filter == null || try(rule.filter.prefix, null) == null ||
        # rule == null || rule.filter == null || rule.filter.prefix == null ||
        # rule == null || rule.filter == null || try(rule.filter.prefix, null)  == null ||
        rule == null || try(rule.filter.prefix, null) == null ||
        (
          # true
          try(rule.filter.prefix, null) != null && try(rule.filter.tag, null) == null && try(rule.filter.object_size_greater_than, null) == null && try(rule.filter.object_size_less_than, null) == null && try(rule.filter.and, null) == null
          # rule.filter.prefix != null && rule.filter.tag == null && rule.filter.object_size_greater_than == null && rule.filter.object_size_less_than == null && rule.filter.and == null
        )
      )
    ])
    error_message = "When a filter with 'prefix' is configured other conditions are not allowed, i.e.: 'tag', 'object_size_greater_than', 'object_size_less_than', or 'and' cannot also be specified."
  }

  validation {
    condition = alltrue([
      for rule in var.lifecycle_rules : (
        rule == null || try(rule.filter.tag, null) == null ||
        (
          try(rule.filter.tag, null) != null && try(rule.filter.prefix, null) == null && try(rule.filter.object_size_greater_than, null) == null && try(rule.filter.object_size_less_than, null) == null && try(rule.filter.and, null) == null
        )
      )
    ])
    error_message = "When a filter with 'tag' is configured other conditions are not allowed, i.e.: 'prefix', 'object_size_greater_than', 'object_size_less_than', or 'and' cannot also be specified."
  }

  validation {
    condition = alltrue([
      for rule in var.lifecycle_rules : (
        rule == null || try(rule.filter.object_size_greater_than, null) == null ||
        (
          try(rule.filter.object_size_greater_than, null) != null && try(rule.filter.prefix, null) == null && try(rule.filter.tag, null) == null && try(rule.filter.object_size_less_than, null) == null && try(rule.filter.and, null) == null
        )
      )
    ])
    error_message = "When a filter with 'object_size_greater_than' is configured other conditions are not allowed, i.e.: 'prefix', 'tag', 'object_size_less_than', or 'and' cannot also be specified."
  }
}

variable "name" {
  type = string

}
