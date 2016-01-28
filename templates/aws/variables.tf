variable "vpc_id" {
  description = "VPC ID which is created by common network pattern."
}
variable "subnet_ids" {
  description = "Subnet ID which is created by common network pattern."
}
variable "shared_security_group" {
  description = "SecurityGroup ID which is created by common network pattern."
}
variable "key_name" {
  description = "Name of an existing EC2/OpenStack KeyPair to enable SSH access to the instances."
}
variable "log_image" {
  description = "[computed] LogServer Image Id. This parameter is automatically filled by CloudConductor."
}
variable "log_instance_type" {
  description = "LogServer instance type"
  default = "t2.small"
}
