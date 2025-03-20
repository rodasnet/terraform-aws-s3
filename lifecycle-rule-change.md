# AWS S3 Bucket Lifecycle Rule Change

## Creating an S3 bucket without

### Terraform Code for Lifecycle 

```terraform

resource "aws_s3_bucket_lifecycle_configuration" "example" {
  bucket = module.bucket.bucket_id

  rule {
    id = "rule-1"

    # ... other transition/expiration actions ...

    status = "Enabled"
  }
}

```
### Terraform Plan Warning 
```terraform

module.bucket.aws_s3_bucket.example: Refreshing state... [id=example-bucket-e4c3]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_s3_bucket_lifecycle_configuration.example will be created
  + resource "aws_s3_bucket_lifecycle_configuration" "example" {
      + bucket                                 = "example-bucket-e4c3"
      + expected_bucket_owner                  = (known after apply)
      + id                                     = (known after apply)
      + transition_default_minimum_object_size = "all_storage_classes_128K"

      + rule {
          + id     = "rule-1"
          + prefix = (known after apply)
          + status = "Enabled"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.
╷
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