output "websiteendpoint" {
  value = aws_s3_bucket_website_configuration.website.id
}