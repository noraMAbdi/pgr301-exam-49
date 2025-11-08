terraform{
    required_version = ">= 1.5.0"

    backend "s3" {
        bucket = "pgr301-terraform-state"
        key = "infra-s3/kandidat-49/terraform.tfstate"
        region = "eu-west-1"
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
resource "aws_s3_bucket" "analyseresultater"{
    bucket = var.bucket_name
}
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle"{
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
