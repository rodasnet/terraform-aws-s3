# variable "lifecycle_rules" {
#   type = list(object({
#     id     = string # Required: Unique identifier for the rule (max 255 characters)
#     status = string # Required: Whether the rule is Enabled or Disabled
#     filter = optional(object({
#       prefix                   = optional(string)
#       tag                      = optional(object({
#         key   = string
#         value = string
#       }))
#       object_size_greater_than = optional(map(any))
#       object_size_less_than    = optional(map(any))
#       and                      = optional(object({
#         prefix = optional(string)
#         tags   = optional(map(any))
#       }))
#     }))
#     expiration                       = optional(object({ /* Expiration config */ }))
#     transition                       = optional(list(object({ /* Transition config */ })))
#     noncurrent_version_expiration    = optional(object({ /* Noncurrent expiration config */ }))
#     noncurrent_version_transition    = optional(list(object({ /* Noncurrent transition config */ })))
#     abort_incomplete_multipart_upload = optional(object({ /* Abort config */ }))
#   }))
#   default = []

#   validation {
#     condition = alltrue([
#       for rule in var.lifecycle_rules : (
#         rule.filter == null || (
#           [!isnull(rule.filter.prefix),
#            !isnull(rule.filter.tag),
#            !isnull(rule.filter.object_size_greater_than),
#            !isnull(rule.filter.object_size_less_than),
#            !isnull(rule.filter.and)]...
#           | length == 1
#         )
#       )
#     ])
#     error_message = "Each filter block must either be empty or have exactly one of 'prefix', 'tag', 'object_size_greater_than', 'object_size_less_than', or 'and' specified."
#   }
# }