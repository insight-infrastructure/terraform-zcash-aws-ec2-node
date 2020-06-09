# terraform-zcash-aws-ec2-node

[![open-issues](https://img.shields.io/github/issues-raw/insight-infrastructure/terraform-zcash-aws-ec2-node?style=for-the-badge)](https://github.com/insight-infrastructure/terraform-zcash-aws-ec2-node/issues)
[![open-pr](https://img.shields.io/github/issues-pr-raw/insight-infrastructure/terraform-zcash-aws-ec2-node?style=for-the-badge)](https://github.com/insight-infrastructure/terraform-zcash-aws-ec2-node/pulls)

## Features

This module sets up an ec2 to run the zcash daemon.  

## Terraform Versions

For Terraform v0.12.0+

## Usage

```hcl-terraform
variable "private_key_path" {}
variable "public_key_path" {}

module "default_vpc" {
  source = "github.com/insight-infrastructure/terraform-aws-default-vpc.git?ref=v0.1.0"
}

resource "aws_security_group" "this" {
  vpc_id = module.default_vpc.vpc_id

  dynamic "ingress" {
    for_each = [
      22,   # ssh
      197, # Add node
      8233, # Add node
      9100, # node exporter
    ]

    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "tcp"
      cidr_blocks = [
        "0.0.0.0/0"]
    }
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

module "defaults" {
  source = "../.."

  minimum_specs = true

  private_key_path = var.private_key_path
  public_key_path  = var.public_key_path

  subnet_id              = module.default_vpc.subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.this.id]
}
```
## Examples

- [defaults](https://github.com/insight-infrastructure/terraform-zcash-aws-ec2-node/tree/master/examples/defaults)

## Known  Issues
No issue is creating limit on this module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| ami\_id | The AMI ID to run | `string` | `""` | no |
| ansible\_hardening | Run hardening roles | `bool` | `false` | no |
| associate\_eip | Boolean to determine if you should associate the ip when the instance has been configured | `bool` | `true` | no |
| create | Boolean to create resources or not | `bool` | `true` | no |
| create\_ebs\_volume | #### EBS #### | `bool` | `false` | no |
| ebs\_volome\_iops | n/a | `string` | n/a | yes |
| ebs\_volume\_id | The volume id of the ebs volume to mount | `string` | `""` | no |
| ebs\_volume\_size | The size of volume - leave as zero or empty for no volume | `number` | `0` | no |
| ebs\_volume\_type | Type of EBS - https://aws.amazon.com/ebs/volume-types/ | `string` | `"gp2"` | no |
| instance\_count | The number of instances to run | `string` | `1` | no |
| instance\_type | Instance type | `string` | `"t2.micro"` | no |
| key\_name | The key pair to import - leave blank to generate new keypair from pub/priv ssh key path | `string` | `""` | no |
| keystore\_password | The password to the keystore | `string` | `""` | no |
| keystore\_path | The path to the keystore | `string` | `""` | no |
| minimum\_specs | Boolean to use minimum specs | `bool` | `false` | no |
| monitoring | Boolean for cloudwatch | `bool` | `false` | no |
| name | The name for the label | `string` | `"prep"` | no |
| network\_name | The network name, ie kusama / mainnet | `string` | `"mainnet"` | no |
| playbook\_vars | Additional playbook vars | `map(string)` | `{}` | no |
| private\_key\_path | The path to the private ssh key | `string` | n/a | yes |
| public\_key\_path | The path to the public ssh key | `string` | n/a | yes |
| root\_iops | n/a | `string` | n/a | yes |
| root\_volume\_size | Root volume size | `string` | `8` | no |
| root\_volume\_type | n/a | `string` | `"gp2"` | no |
| subnet\_id | The id of the subnet | `string` | n/a | yes |
| tags | Map of tags | `map(string)` | `{}` | no |
| volume\_path | The path of the EBS volume | `string` | `"/dev/xvdf"` | no |
| vpc\_security\_group\_ids | List of security groups | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| dhcp\_ip | n/a |
| ebs\_volume\_arn | n/a |
| instance\_id | n/a |
| instance\_store\_enabled | n/a |
| instance\_type | n/a |
| key\_name | n/a |
| network\_name | n/a |
| public\_ip | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Testing
This module has been packaged with terratest tests

To run them:

1. Install Go
2. Run `make test-init` from the root of this repo
3. Run `make test` again from root

## Authors

Module managed by [insight-infrastructure](https://github.com/insight-infrastructure)

## Credits

- [Anton Babenko](https://github.com/antonbabenko)

## License

Apache 2 Licensed. See LICENSE for full details.