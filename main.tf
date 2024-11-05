terraform {
  cloud {
    organization = "fcamba-org"

    workspaces {
      name = "demo-eks-cluster"
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
  workspace = "demo-landing-zone-aws"
}