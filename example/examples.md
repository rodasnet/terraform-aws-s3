# S3 Buckets 

## Lifecycle Rule Variable Validation

Default error and warnings are ambigous for lifecycle rule resources, this update creates specific validation rules for each lifecycle rule scenario.

### Example Misconfigured Module for Lifecycle Rule

```terraform
module "bucket_with_lifecycle_vialation_tag_and_prefix" {
  source = "../"

  name = "bucket-lifecycle-tag-prefix-3j3j"

  lifecycle_rules = [
    {
      id     = "example-rule-00"
      status = "Enabled"
      filter = {
        tag = {
          key   = "example-key"
          value = "example-value"
        }
        prefix = "/"
      }
      abort_incomplete_multipart_upload = {
        days_after_initiation = 7
      }
    }
  ]
}
```

### Default Terrafomr Warnings is Ambigous
```terraform
╷╷
│ Warning: Invalid Attribute Combination
│
│   with aws_s3_bucket_lifecycle_configuration.example,
│   on main.tf line 10, in resource "aws_s3_bucket_lifecycle_configuration" "example":
│   10:   rule {
│
│ No attribute specified when one (and only one) of [rule[0].prefix.<.filter] is required
│
│ This will be an error in a future version of the provider
│
│ (and one more similar warning elsewhere)
```
### Improved Terrafomr Warnings is Indicate Specific Filter That Need Correction

```terraform
│ Error: Invalid value for variable
│
│   on examples.tf line 117, in module "bucket_with_lifecycle_vialation_tag_and_prefix":
│  117:   lifecycle_rules = [
│  118:     {
│  119:       id     = "example-rule-00"
│  120:       status = "Enabled"
│  121:       filter = {
│  122:         tag = {
│  123:           key   = "example-key"
│  124:           value = "example-value"
│  125:         }
│  126:         prefix = "/"
│  127:       }
│  128:       abort_incomplete_multipart_upload = {
│  129:         days_after_initiation = 7
│  130:       }
│  131:     }
│  132:   ]
│     ├────────────────
│     │ var.lifecycle_rules is list of object with 1 element
│
│ When a filter with 'prefix' is configured other conditions are not allowed, i.e.: 'tag', 'object_size_greater_than', 'object_size_less_than', or 'and' cannot also be specified.
│
│ This was checked by the validation rule at ../variables.tf:42,3-13.
╵
╷
│ Error: Invalid value for variable
│
│   on examples.tf line 117, in module "bucket_with_lifecycle_vialation_tag_and_prefix":
│  117:   lifecycle_rules = [
│  118:     {
│  119:       id     = "example-rule-00"
│  120:       status = "Enabled"
│  121:       filter = {
│  122:         tag = {
│  123:           key   = "example-key"
│  124:           value = "example-value"
│  125:         }
│  126:         prefix = "/"
│  127:       }
│  128:       abort_incomplete_multipart_upload = {
│  129:         days_after_initiation = 7
│  130:       }
│  131:     }
│  132:   ]
│     ├────────────────
│     │ var.lifecycle_rules is list of object with 1 element
│
│ When a filter with 'tag' is configured other conditions are not allowed, i.e.: 'prefix', 'object_size_greater_than', 'object_size_less_than', or 'and' cannot also be specified.
│
│ This was checked by the validation rule at ../variables.tf:61,3-13.
```