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

variable "aws_region" {
  description = "aws region"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "s3 backend bucket name"
  type        = string
  default     = "us-east-1"
}