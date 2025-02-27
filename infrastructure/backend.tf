terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "nginx/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
