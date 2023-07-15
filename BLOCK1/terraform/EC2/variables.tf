variable "machine_image" {
  type    = string
  default = "ami-0ec7f9846da6b0f61"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "zurich_instance_azs" {
  type    = string
  default = "eu-central-1a"
}

variable "zurich_subnet_id" {
  type = string
}

variable "zurich_security_group" {
  type = string
}
