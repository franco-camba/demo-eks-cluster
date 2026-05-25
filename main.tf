terraform {
  cloud {
    organization = "fcamba-org"

    workspaces {
      name = "demo-eks-cluster"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.33" # EKS access entries require provider >= 5.33
    }
    tfe = {
      source = "hashicorp/tfe"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

provider "tfe" {
  hostname = var.tfc_hostname
  token    = var.tfe_token
}

data "tfe_outputs" "subnet" {
  organization = "fcamba-org"
  workspace    = "demo-landing-zone-aws"
}