# terraform-aws-s3

Creates an S3 bucket with optional lifecycle rules. Validates lifecycle rule
filter combinations at plan time instead of surfacing the underlying
provider's ambiguous runtime warning - see [`examples/`](examples/) for why
and for example calls covering every supported filter shape.

## Usage

```hcl
module "bucket" {
  source  = "app.terraform.io/rodasnet/s3/aws"
  version = "~> 1.0"

  name = "my-bucket"

  lifecycle_rules = [
    {
      id     = "expire-logs"
      status = "Enabled"
      filter = {
        prefix = "logs/"
      }
      expiration = {
        days = 30
      }
    }
  ]
}
```

<!-- terraform-docs markers below - BEGIN_TF_DOCS/END_TF_DOCS populated by
     the terraform_docs pre-commit hook, not written by hand. -->
