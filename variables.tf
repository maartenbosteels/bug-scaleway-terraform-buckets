
variable "project_id" {
  type = string
}

variable "bucket_suffix" {
  description = "A suffix for the bucket"
  default     = "_random"
  type        = string
}

variable "terraform_iam_application_name" {
  description = "The name of the IAM application that tofu uses to create the resources in this folder"
  default     = "terraform-buckets-bug"
  type        = string
}