variable "create" {
  description = "Boolean to create resources or not"
  type        = bool
  default     = true
}

variable "minimum_specs" {
  description = "Boolean to use minimum specs"
  type        = bool
  default     = false
}


########
# Label
########
variable "name" {
  description = "The name for the label"
  type        = string
  default     = "prep"
}

variable "tags" {
  description = "Map of tags"
  type        = map(string)
  default     = {}
}

variable "network_name" {
  description = "The network name, ie kusama / mainnet"
  type        = string
  default     = "mainnet"
}

######
# Data
######
variable "subnet_id" {
  description = "The id of the subnet"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of security groups"
  type        = list(string)
}

#####
# ec2
#####
variable "instance_count" {
  description = "The number of instances to run"
  type        = string
  default     = 1
}

variable "key_name" {
  description = "The key pair to import - leave blank to generate new keypair from pub/priv ssh key path"
  type        = string
  default     = ""
}

variable "monitoring" {
  description = "Boolean for cloudwatch"
  type        = bool
  default     = false
}

variable "root_volume_size" {
  description = "Root volume size"
  type        = string
  default     = 8
}

variable "root_volume_type" {
  description = ""
  type        = string
  default     = "gp2"
}

variable "root_iops" {
  description = ""
  type        = string
  default     = null
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "public_key_path" {
  description = "The path to the public ssh key"
  type        = string
}

variable "private_key_path" {
  description = "The path to the private ssh key"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID to run"
  type        = string
  default     = ""
}

#####
# EBS
#####
variable "create_ebs_volume" {
  type    = bool
  default = false
}

variable "ebs_volume_id" {
  type        = string
  default     = ""
  description = "The volume id of the ebs volume to mount"
}

variable "ebs_volume_size" {
  description = "The size of volume - leave as zero or empty for no volume"
  type        = number
  default     = 0
}

variable "ebs_volume_type" {
  description = "Type of EBS - https://aws.amazon.com/ebs/volume-types/"
  type        = string
  default     = "gp2"
}

variable "ebs_volome_iops" {
  description = ""
  type        = string
  default     = null
}

variable "volume_path" {
  description = "The path of the EBS volume"
  type        = string
  default     = "/dev/xvdf"
}

#########
# Ansible
#########
variable "ansible_hardening" {
  description = "Run hardening roles"
  type        = bool
  default     = false
}

variable "playbook_vars" {
  description = "Additional playbook vars"
  type        = map(string)
  default     = {}
}

variable "keystore_path" {
  description = "The path to the keystore"
  type        = string
  default     = ""
}

variable "keystore_password" {
  description = "The password to the keystore"
  type        = string
  default     = ""
}

variable "associate_eip" {
  description = "Boolean to determine if you should associate the ip when the instance has been configured"
  type        = bool
  default     = true
}



