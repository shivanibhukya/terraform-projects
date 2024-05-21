provider "aws" {
  region = "us-east-1"
}



# Create S3 bucket
resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname
}

# Configure bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "mybucket_ownership_controls" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Configure public access block
resource "aws_s3_bucket_public_access_block" "mybucket_public_access_block" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Configure bucket ACL
resource "aws_s3_bucket_acl" "mybucket_acl" {
  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"

  depends_on = [
    aws_s3_bucket_ownership_controls.mybucket_ownership_controls,
    aws_s3_bucket_public_access_block.mybucket_public_access_block,
  ]
}

# Upload index.html object
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.mybucket.id
  key          = "index.html"
  source       = "index.html"  # Verify the file path
  acl          = "public-read"
  content_type = "text/html"
}

# Upload error.html object
resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.mybucket.id
  key          = "error.html"
  source       = "error.html"  # Verify the file path
  acl          = "public-read"
  content_type = "text/html"
}

# Upload profile.png object
resource "aws_s3_object" "profile" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "profile.png"
  source = "profile.png"  # Verify the file path
  acl    = "public-read"
}

# Configure S3 bucket website hosting
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mybucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [aws_s3_bucket_acl.mybucket_acl]
}
