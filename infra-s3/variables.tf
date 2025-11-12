variable "aws_region" {
    description = "Region for bucket"
    default = "eu-west-1"
}

variable "bucket_name"{
    description = "pg301-eksamen"
    type = string
}
variable "days_to_glacier" {
    description = "Antall dager før filer flyttes til Glacier"
    default = 90
}

variable "days_to_delete"{
    description = "Antall dager før filer slettes"
    default = 90
}