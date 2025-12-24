# Secrets Manager Secret for x509 Private CA
resource "aws_secretsmanager_secret" "adi-r640-ca-bundle" {
  name = "adi-r640-ca-bundle"
}

# Retrieve the secret value
data "aws_secretsmanager_secret_version" "adi-r640-ca-bundle" {
  secret_id = aws_secretsmanager_secret.adi-r640-ca-bundle.id
}

# Roles Anywhere Trust Anchor
resource "aws_rolesanywhere_trust_anchor" "adi-r640-ca" {
  enabled = true
  name = "ADI R640 Private CA"
  source {
    source_type = "CERTIFICATE_BUNDLE"
    source_data {
      x509_certificate_data = data.aws_secretsmanager_secret_version.adi-r640-ca-bundle.secret_string
    }
  }
}

output "trust-anchor-arn" {
  value = aws_rolesanywhere_trust_anchor.adi-r640-ca.arn
}

# Roles Anywhere Profile with S3 Access Role
resource "aws_rolesanywhere_profile" "r640-restic-s3" {
  enabled = true
  name = "r640-restic-s3"
  role_arns = [aws_iam_role.restic-iam-role.arn]
}

output "rolesanywhere_profile_arn" {
  value = aws_rolesanywhere_profile.r640-restic-s3.arn
}