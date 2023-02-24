
## S3 and Dynamodb setup for S3 backend with statefile locking


### Usage

    ```bash
    $ terraform init -var=s3_bucket_name="<S3-BUCKET-NAME>" -var=dynamodb_name="<Dyanamodb-NAME>"
    $ terraform plan -var=s3_bucket_name="<S3-BUCKET-NAME>" -var=dynamodb_name="<Dyanamodb-NAME>"
    $ terraform apply -var=s3_bucket_name="<S3-BUCKET-NAME>" -var=dynamodb_name="<Dyanamodb-NAME>"
    ```
    
### Get the S3 bucket and Dyanamo DB values from the output for use.
