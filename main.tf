#Creat s3 bucket

resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.mybucket.id
  key          = "index.html"
  source       = "index.html"
  acl          = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.mybucket.id
  key          = "error.html"
  source       = "error.html"
  acl          = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "pic" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "pic.PNG"
  source = "pic.PNG"
  acl    = "public-read"
}


# resource "aws_s3_bucket_object" "assets" {
#   for_each = fileset("C:/Users/Abdul/Desktop/Cloud Projects/s3-staticwebsite-terraform/carvilla/", "**")
#   bucket   = aws_s3_bucket.mybucket.id
#   key      = each.value
#   source   = "C:/Users/Abdul/Desktop/Cloud Projects/s3-staticwebsite-terraform/carvilla/${each.value}"
#   etag     = filemd5("C:/Users/Abdul/Desktop/Cloud Projects/s3-staticwebsite-terraform/carvilla/${each.value}")
#   acl      = "public-read"
# }

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mybucket.id

  index_document {
    suffix = "index.html"
  }

  depends_on = [aws_s3_bucket_acl.example]

}
