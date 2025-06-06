variable "lifecycle_rules--UPDATE" {
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
      date          = optional(string) # Expiration date in YYYY-MM-DD format (expected by Terraform)
      days          = optional(number) # Expiration in days
      delete_marker = optional(bool)   # Whether to expire delete markers
    }))
    transition = optional(list(object({ # Optional: Specifies transition configuration
      date          = optional(string)  # Transition date in YYYY-MM-DD format (expected by Terraform)
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

  # Existing validation for filter conditions
  validation {
    condition = alltrue([
      for rule in var.lifecycle_rules : (
        rule == null || try(rule.filter.prefix, null) == null ||
        (
          try(rule.filter.prefix, null) != null && try(rule.filter.tag, null) == null && try(rule.filter.object_size_greater_than, null) == null && try(rule.filter.object_size_less_than, null) == null && try(rule.filter.and, null) == null
        )
      )
    ])
    error_message = "When a filter with 'prefix' is configured other conditions are not allowed, i.e.: 'tag', 'object_size_greater_than', 'object_size_less_than', or 'and' cannot also be specified."
  }

  # New validation for date format
  validation {
    condition = alltrue([
      for rule in var.lifecycle_rules : (
        # Check expiration date format if present
        (lookup(try(rule.expiration, {}), "date", null) == null || can(regex("^\\d{4}-\\d{2}-\\d{2}(T\\d{2}:\\d{2}:\\d{2}Z)?$", rule.expiration.date))) &&
        # Check transition date format if present (assuming you might add date-based transition rules)
        alltrue([
          for transition_rule in try(rule.transition, []) :
          (lookup(transition_rule, "date", null) == null || can(regex("^\\d{4}-\\d{2}-\\d{2}(T\\d{2}:\\d{2}:\\d{2}Z)?$", transition_rule.date)))
        ])
      )
    ])
    error_message = "Expiration or transition date must be in YYYY-MM-DD or YYYY-MM-DDTHH:MM:SSZ format."
  }
}
