resource "rancher2_cloud_credential" "aws_cred" {
  name = var.cloud_credential

  amazonec2_credential_config {
    access_key     = var.aws_access_key
    secret_key     = var.aws_secret_key
    default_region = "us-east-1"
  }
}
