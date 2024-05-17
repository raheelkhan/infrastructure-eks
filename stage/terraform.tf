terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.49.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.12.1"
    }
  }

  backend "s3" {

  }

  required_version = "1.8.1"
}

