variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "ExampleAppServerInstance"
}

variable "instance_type" {
  description = "Value of type for the EC2 instance"
  type        = string
  default     = "t2.small"
}

variable "alb_sg_id" {
  description = "sg for the EC2 instance"
  type        = string
}

variable "target_group_arn" {
  description = "target_group_arn for the EC2 instance"
  type        = string
}