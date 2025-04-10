
resource "aws_s3_bucket" "lakefs" {
  bucket = local.resource_name_default
}
