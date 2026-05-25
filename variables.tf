variable "tfe_token" {
  type    = string
  default = ""
}

variable "tfc_hostname" {
  type    = string
  default = "app.terraform.io"
}

variable "tfc_organization_name" {
  type        = string
  default     = "fcamba-org"
  description = "The name of your Terraform Cloud organization"
}

variable "desired_ng_size" {
  default = "1"
}

variable "cluster_admin_principal_arn" {
  type        = string
  description = "IAM role ARN granted cluster-admin via an EKS access entry. Use the base role ARN (no assumed-role session), e.g. your Doormat developer role."
  default     = "arn:aws:iam::307459862233:role/aws_franco.camba_test-developer"
}