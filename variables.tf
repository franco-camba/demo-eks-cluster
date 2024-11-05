variable "tfe_token" {
    type = string
    default = ""
}

variable "tfc_hostname" {
    type = string
    default = "app.terraform.io"
}

variable "tfc_organization_name" {
  type        = string
  default = "fcamba-org"
  description = "The name of your Terraform Cloud organization"
}