terraform {
  backend "s3" {
    bucket         = "terraform-eks-state-aniket-dubey-unique"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    use_lockfile   = true
  }
}