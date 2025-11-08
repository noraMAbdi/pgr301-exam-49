variable "aws_region" {
    description = "Region for bucket"
    default = "eu-north-1"
}

variable "bucket_name"{
    description = "Navn på S3 bucket"
    type = string
}
variable "days_to_glacier" {
    description = "Antall dager før filer flyttes til Glacier"
    default = 7
}

variable "days_to_delete"{
    description = "Antall dager før filer slettes"
    default = 30
}