
# Crear el bucket S3
resource "aws_s3_bucket" "labfinal_bucket" {
  bucket = var.s3_config.bucket_name
  tags = merge(var.tags, { Name = var.s3_config.bucket_name })
}

# Configurar el versionado del bucket
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.labfinal_bucket.id
  versioning_configuration {
    status = var.s3_config.versioning
  }
}

# Política del bucket
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.labfinal_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowEC2Access"
        Effect    = "Allow"
        Principal = {
          AWS = aws_iam_role.labfinal_roles.arn
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = [
          "${aws_s3_bucket.labfinal_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Bloquear el acceso público
resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
  bucket = aws_s3_bucket.labfinal_bucket.id

  block_public_acls       = var.s3_public_access.block_public_acls
  block_public_policy     = var.s3_public_access.block_public_policy
  ignore_public_acls      = var.s3_public_access.ignore_public_acls
  restrict_public_buckets = var.s3_public_access.restrict_public_buckets
}