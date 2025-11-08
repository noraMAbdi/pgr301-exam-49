terraform{
    required_version = ">= 1.5.0"

    backend "s3" {
        bucket = "pgr301-terraform-state"
        key = "infra-s3/terraform.tfstate"
        region = "eu-north-1"
    }
    required_providers{
        aws = {
                source = "hashicorp/aws"
                version = "~>5.0"
            }
        }
    }
provider "aws" {
    region = var.aws_region
    }
resources "aws_s3_bucket" "analyseresultater"{
    bucket = aws_s3_bucket.analyseresultater.id

    rule {
        id = "midlertidig_filer"
        status = "Enabled"
        filter {
            prefix = "midlertidig/"
        }
        transition {
            days = var.days_to_glacier
            storage_class = "GLACIER"
        }
        expiration {
            days = var.days_to_delete
            }
        }
}
output "bucket_name" {
    value = aws_s3_bucket.analyseresultater.bucket
}
output "bucket_region"{
    var.aws_region
 }