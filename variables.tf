variable "region" {
  type    = string
  default = "us-west-2"
}

variable "access_ip" {
  type = string
}

variable "db_subnet_group" {
  type    = bool
  default = false
}

variable "dbname" {
  type = string
}

variable "dbuser" {
  type      = string
  sensitive = true
}

variable "dbpassword" {
  type      = string
  sensitive = true
}

variable "tg_port" {
  type = number
  default = 80
}

variable "healthy_threshold" {
  type    = number
  default = 2
}

variable "unhealthy_threshold" {
  type    = number
  default = 2
}

variable "lb_timeout" {
  type    = number
  default = 3
}

variable "lb_interval" {
  type    = number
  default = 30
}

variable "listener_port" {
   type    = number
  default = 80 
}

variable "listener_protocol" {
   type    = string
  default = "HTTP" 
}