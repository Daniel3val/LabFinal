terraform {
  backend "s3" {
    bucket = "labfinal-tfstate-daniel"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
} 