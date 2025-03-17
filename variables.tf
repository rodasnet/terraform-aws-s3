variable "s3_bucket_lifecycle_rules" {
  type = list(object({
    id     = string            # Required: Unique identifier for the rule (max 255 characters)
    status = string            # Required: Whether the rule is Enabled or Disabled
    filter = optional(object({ # Optional: Used to identify objects the rule applies to
      prefix = optional(string)
      tags   = optional(map(string))
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
}

variable "name" {
  type = string
  
}
