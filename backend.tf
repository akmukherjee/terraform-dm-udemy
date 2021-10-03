terraform {
  backend "remote" {
    organization = "Self-Amit"

    workspaces {
      name = "aws-terraform-dm-course"
    }
  }
}