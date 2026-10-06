# Examples

See `main.tf` for example calls covering each `lifecycle_rules` filter shape
this module supports: no rules, a default rule with no filter, `prefix`,
`tag`, `and`, and `object_size_greater_than`/`object_size_less_than`.

## Why `lifecycle_rules` has its own validation blocks

The underlying `aws_s3_bucket_lifecycle_configuration` resource's `filter`
block must be either empty or have *exactly one* of `prefix`, `tag`, `and`,
`object_size_greater_than`, or `object_size_less_than` set - they're mutually
exclusive. Left unvalidated, misconfiguring this produces an unhelpful
provider warning that doesn't point at the actual problem:

```
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
```

`variables.tf`'s validation blocks catch this at plan time instead, with an
error that names the actual conflicting fields:

```
│ Error: Invalid value for variable
│
│ When a filter with 'prefix' is configured other conditions are not allowed,
│ i.e.: 'tag', 'object_size_greater_than', 'object_size_less_than', or 'and'
│ cannot also be specified.
│
│ This was checked by the validation rule at ../variables.tf:42,3-13.
```
