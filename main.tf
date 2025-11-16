# main.tf

data "scaleway_iam_application" "main" {
  name = "terraform-buckets-bug"
}

resource "scaleway_object_bucket" "main" {
  name       = "terraform-provider-scaleway-issues-3300-${var.bucket_suffix}"
  project_id = var.project_id
}

resource "scaleway_object_bucket_policy" "policy" {
  bucket = scaleway_object_bucket.main.id
  policy = jsonencode(
    {
      Version = "2023-04-17",
      Statement = [
        {
          Effect = "Allow",
          Principal = {
            SCW = "application_id:${data.scaleway_iam_application.main.id}"
          },
          Action = [
            "s3:ListBucket",
          ]
          Resource = [
            "${scaleway_object_bucket.main.name}",
            "${scaleway_object_bucket.main.name}/*",
          ]
        },
        {
          Effect = "Allow",
          Principal = {
            SCW = "application_id:${data.scaleway_iam_application.main.id}",
          },
          Action = [
            "s3:GetBucketCORS",
            "s3:GetBucketAcl",
          ]
          Resource = [
            "${scaleway_object_bucket.main.name}",
            "${scaleway_object_bucket.main.name}/*",
          ]
        }
      ]
    }
  )
}

