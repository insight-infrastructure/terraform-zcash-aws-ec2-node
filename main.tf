resource "random_pet" "this" {}

module "ami" {
  source = "github.com/insight-infrastructure/terraform-aws-ami.git?ref=v0.1.0"
}

resource "aws_key_pair" "this" {
  count      = var.public_key_path != "" && var.create ? 1 : 0
  public_key = file(var.public_key_path)
}

locals {
  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_ebs_volume" "this" {
  count = ! local.instance_store_enabled && var.create && var.ebs_volume_size > 0 ? 1 : 0

  availability_zone = join("", aws_instance.this.*.availability_zone)

  size = var.ebs_volume_size
  type = var.ebs_volume_type
  iops = var.ebs_volome_iops

  tags = local.tags
}

resource "aws_volume_attachment" "this" {
  count = ! local.instance_store_enabled && var.create && var.ebs_volume_size > 0 ? 1 : 0

  device_name  = var.volume_path
  volume_id    = aws_ebs_volume.this.*.id[0]
  instance_id  = join("", aws_instance.this.*.id)
  force_detach = true
}

locals {
  ami_id = var.ami_id != "" ? var.ami_id : module.ami.ubuntu_1804_ami_id
}

resource "aws_instance" "this" {
  count         = var.create ? var.instance_count : 0
  ami           = local.ami_id
  instance_type = local.instance_type

  root_block_device {
    volume_size = local.root_volume_size
    volume_type = var.root_volume_type
    iops        = var.root_iops
  }

  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids

  key_name = var.public_key_path == "" ? var.key_name : aws_key_pair.this.*.key_name[0]

  tags = local.tags
}

module "ansible" {
  source           = "github.com/insight-infrastructure/terraform-aws-ansible-playbook.git?ref=v0.10.0"
  create           = var.create && var.ami_id == ""
  ip               = join("", aws_eip.public_ip.*.public_ip)
  user             = "ubuntu"
  private_key_path = var.private_key_path

  playbook_file_path = "${path.module}/ansible/main.yml"
  playbook_vars = merge({
    testnet = 1
    addnode = "testnet.z.cash"
    server  = 1
    bind    = "0.0.0.0"
  }, var.playbook_vars)

  requirements_file_path = "${path.module}/ansible/requirements.yml"
}

resource "aws_eip" "public_ip" {
  tags = var.tags
}

resource "aws_eip_association" "main_ip" {
  count       = var.associate_eip && var.create ? 1 : 0
  instance_id = join("", aws_instance.this.*.id)
  public_ip   = join("", aws_eip.public_ip.*.public_ip)
}

