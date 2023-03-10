
## S3 backend and AWS resource configurations

### Configuration in this directory creates
- S3 backend with statefile locking
- AWS resources: VPC with 3 private and 3 public subnets, EC2, RDS (Postgres), IGW, NAT and Security groups

### Usage
- To run this example, you need to first create S3 bucket and dynamodb, and replace values in s3_backend.tf file under terraform block for configuring S3 backend with statefile locking successfully. These can be created using the terraform configuration file under "S3-dyanamodb-setup" folder.
- Next, below commands can be run to initialize and apply.

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

## Modules

- VPC: ./modules/aws_demo/vpc
- RDS: ./modules/aws_demo/rds 
- EC2: ./modules/aws_demo/ec2
