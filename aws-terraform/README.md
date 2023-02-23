
## S3 backend and AWS resource configurations

### Configuration in this directory creates:
- S3 backend with statefile locking
- AWS resources: VPC with 3 private and 3 public subnets, EC2, RDS (Postgres), IGW, NAT and Security groups

### Usage
- To run this example, you need to first create S3 bucket and dynamodb, and replace values in s3_terraform.tf file under terraform block for configuring S3 backend with statefile locking successfully.
- Next, below commands can be run to initialize and apply.

    ```bash
    $ terraform init
    $ terraform plan
    $ terraform apply
    ```
    

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
