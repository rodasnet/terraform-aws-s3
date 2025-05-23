locals {
#   input_date = "2026-01-13T00:00:00Z"
#   input_date = "2026-01-13T00:00:00"
  input_date = "2028-01-13"
#   input_date = "2028-01-13T00:00:00Z"
#   input_date = null

  # Strictly match the RFC3339 format: YYYY-MM-DDT00:00:00Z
#   is_long_form = can(regex("^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}Z$", local.input_date))


  # Check if formatdate can process the input, meaning it's already long-form
#   is_long_form = can(formatdate("YYYY-MM-DD'T'HH:mm:ssZ", local.input_date))

#   formatted_date = local.is_long_form ? local.input_date : "${local.input_date}T00:00:00Z"

  # Check if formatdate can process the input, meaning it's already long-form - SINGLE LINE
  formatted_date = try(local.input_date, null) != null ? (can(formatdate("YYYY-MM-DD'T'HH:mm:ssZ", local.input_date)) ? local.input_date : "${local.input_date}T00:00:00Z") : null
}

output "final_date" {
  value = local.formatted_date
}