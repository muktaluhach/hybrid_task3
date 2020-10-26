//WordPress AMI ID Variable
variable "wordpress" {
  type    = string
  default = "ami-01686edc2b2c69ed3"
}

//MySQL AMI ID Variable
variable "mysql" {
  type    = string
  default = "ami-09cafbf9a2b69fb27"
}

//Instance Type Variable
variable "inst_type" {
  type    = string
  default = "t2.micro"
}

variable "name" {
  type = string
  default = "ami-0e306788ff2473ccb"
}


 