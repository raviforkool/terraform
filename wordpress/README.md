## Wordpress application setup on AWS.

### Configuration in this directory creates:
- Installs wordpress on EC2 with RDS MySQL as a backend.

### Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```
#### Note: Please check the main.tf file for the AZs, VPC, region, subnet cidrs, ec2/rds instance type and update as required before running.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.55.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.55.0 |
