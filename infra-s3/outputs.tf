output "bucket_name"{
    value = aws_s3_bucket.analyseresultater.bucket
}
output "bucket_region"{
    value = var.aws_region
}