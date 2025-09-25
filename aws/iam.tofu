# IAM Policy for Restic to access the backup bucket
resource "aws_iam_policy" "restic-bucket-access" {
  name = "restic-bucket-access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "ResticBackups",
      Effect = "Allow",
      Action = [
        "s3:ListBucket",
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:AbortMultipartUpload",
        "s3:ListBucketMultipartUploads",
        "s3:ListMultipartUploadParts"
      ]
      Resource = aws_s3_bucket.r640-backup.arn
    }]
  })
}

# Restic IAM Roles Anywhere Role
resource "aws_iam_role" "restic-iam-role" {
  name = "restic-rolesanywhere-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "rolesanywhere.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession",
          "sts:SetSourceIdentity"
        ]
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = [
              aws_rolesanywhere_trust_anchor.adi-r640-ca.arn
            ]
          }
          StringEquals = {
            "aws:PrincipalTag/x509Issuer/CN" = "ADI R640 Root CA"
          }
        }
      },
    ]
  })
}

output "restic-r640-policy-arn" {
  value = aws_iam_role.restic-iam-role.arn
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "restic-role-permissions" {
  policy_arn = aws_iam_policy.restic-bucket-access.arn
  role       = aws_iam_role.restic-iam-role.name
}
