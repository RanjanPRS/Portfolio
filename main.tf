terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.40.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
  access_key = ""
  secret_key = ""
}

resource "aws_s3_bucket" "r1" {
  bucket = my-stat-wbesite-terraform-2024
}


resource "aws_s3_bucket_ownership_controls" "r2" {
  bucket = aws_s3_bucket.r1.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket_public_access_block" "r3" {
  bucket = aws_s3_bucket.r1.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_acl" "r4" {
  depends_on = [
    aws_s3_bucket_ownership_controls.r2,
    aws_s3_bucket_public_access_block.r3,
  ]

  bucket = aws_s3_bucket.r1.id
  acl    = "public-read"
}



resource "aws_s3_object" "r5" {
  bucket = aws_s3_bucket.r1.id
  key    = "index.html"
  source = "/home/ubuntu/statwebsite/index.html"
  content_type = "text/html"
}


resource "aws_s3_object" "r6" {
  bucket = aws_s3_bucket.r1.id
  key    = "error.html"
}