# ---- loadbalancing/variables.tf

variable "public_sg" {}
variable "public_subnets" {}
variable "vpc_id" {}
variable "tg_port" {}
variable "healthy_threshold" {}
variable "unhealthy_thredhold" {}
variable "lb_timeout" {}
variable "lb_interval" {}
variable "listener_port" {}
variable "listener_protocol" {}

