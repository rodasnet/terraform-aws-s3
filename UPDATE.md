## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.92.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | n/a | <pre>list(object({<br/>    id     = string            # Required: Unique identifier for the rule (max 255 characters)<br/>    status = string            # Required: Whether the rule is Enabled or Disabled<br/>    filter = optional(object({ # Optional: Used to identify objects the rule applies to<br/>      prefix = optional(string)<br/>      tag = optional(object({<br/>        key   = string<br/>        value = string<br/>      }))<br/>      object_size_greater_than = optional(number)<br/>      object_size_less_than    = optional(number)<br/>      and = optional(object({<br/>        prefix                   = optional(string)<br/>        tags                     = optional(map(string))<br/>        object_size_greater_than = optional(number)<br/>        object_size_less_than    = optional(number)<br/>      }))<br/>    }))<br/>    expiration = optional(object({     # Optional: Specifies expiration configuration<br/>      date          = optional(string) # Expiration date in ISO 8601 format<br/>      days          = optional(number) # Expiration in days<br/>      delete_marker = optional(bool)   # Whether to expire delete markers<br/>    }))<br/>    transition = optional(list(object({ # Optional: Specifies transition configuration<br/>      days          = optional(number)  # Transition after days<br/>      storage_class = string            # Target storage class (e.g., GLACIER, STANDARD_IA)<br/>    })))<br/>    noncurrent_version_expiration = optional(object({ # Optional: Expiration for noncurrent object versions<br/>      noncurrent_days = number                        # Number of days after which noncurrent versions expire<br/>    }))<br/>    noncurrent_version_transition = optional(list(object({ # Optional: Transition for noncurrent object versions<br/>      storage_class   = string                             # Target storage class<br/>      noncurrent_days = number                             # Number of days after which to transition<br/>    })))<br/>    abort_incomplete_multipart_upload = optional(object({ # Optional: Cleanup for incomplete multipart uploads<br/>      days_after_initiation = number                      # Days since initiation to abort incomplete uploads<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | The ARN of the S3 bucket |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | The ID (name) of the S3 bucket |
