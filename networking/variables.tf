# ---- networking/variables.tf
variable "cidr_block" {}
variable "public_cidrs" {
  type = list(any)
}
variable "private_cidrs" {
  type = list(any)
}
variable "public_sn_count" {}
variable "private_sn_count" {}

variable "max_subnets" {
  type = number

}
variable "access_ip" {}
variable "security_groups" {}

variable "db_subnet_group" {}