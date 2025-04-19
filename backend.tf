terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-aditya123"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    use_lockfile   = true
  }
}