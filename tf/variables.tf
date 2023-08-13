variable "access_key" {
description = "The AWS access key."
}

variable "secret_key" {
description = "The AWS access secret."
}

variable "region" {
description = "The AWS region." 
default = "eu-west-3"
}

variable "prefix" {
  default = "playground"
  description = "The name of our org, i.e. examplecom."
  }

variable "environment" {
  default = "development"
  description = "The name of the environment."
 }

variable "account-id-share" {
  description = "AccountID to share resolver rules"
 }
