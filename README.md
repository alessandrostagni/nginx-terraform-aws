# nginx-terraform-aws

A simple AWS stack deployed through terraform on AWS. Consists of:

- EC2 t2.micro instance running Amazon Linux AMI 2.
- EC2 user data for initialising the instance.
- IAM role for the instance with permissions to download configurations and script from S3.
- Small VPC with public subnet where the instance is deployed.
- S3 bucket that will contain scripts and configurations for the instance. Encrypted with KMS key.
- S3 objects: The scripts and configuration for the instance.
- Optional (commented) resources for SSH access the instance. See comments in `ec2.tf`,`vpc.tf` and `ec2_user_data.sh`
- Optional (commented) remote state management through S3 + DynamoDB for lock. See comment in `backend.tf`.

## Deployment

Simply deploy the stack in any region with:

`bash deploy.sh [AWS_ACCESS_KEY_ID] [AWS_SECRET_ACCESS_KEY] [AWS_REGION]`

Terraform will be initialised and will start planning automatically.
You will be prompted with Terraform asking to confirm whether you want the plan to be deployed.

No manual configuration is needed for the instance.
Once the instance starts, the user data will take care of installing everything.
If you want more information on how the instance is configured, check the `ec2_user_data.sh` file.
After a couple of minutes you'll be able to access the following services by using the instance public ip:

- Nginx welcome page at `/` on port 80.
- `resource.log` containing information  produced by the logger at `/resource.log` on port 80. Served by Nginx
- Search service for querying logs at `/search` on port 8000. See below on how to query the service.

Note that the REST server for searching through the logs is not served through Nginx, so that it is possible to query the logs even if the Nginx container breaks. Still discouraged to expose Flask on its own, though.

## Basic search

You will be able to get logs between a `start_date` and `end_date`.
You can specify the date in any of the formats specified [here](https://dateutil.readthedocs.io/en/stable/parser.html).

Here is an example:

`curl http://ec2-x-xx-xxx-xxx.xx-x-x.compute.amazonaws.com:8000/search?startdate=Sun Sep 19 12:21:54 UTC 2021&enddate=Sun Sep 19 12:22:29 UTC 2021`

Logs matching the query will be returned in JSON format.

## Destroy

In order to remove all the resources deployed just run:

`bash destroy.sh [AWS_ACCESS_KEY_ID] [AWS_SECRET_ACCESS_KEY] [AWS_REGION]`


### Known risks and issues

- Flask exposed directly. Not secure.
- Log file grows infinitely.
- Log records returned by the search could be partial, as each log is filled incrementally (see `logger.sh`).
- No testing (e.g. pytest for script).
- Using Amazon Linux default python3.
- EC2 User Data runs only the first time the instance is created. Restarting the instance will not cause the services to be restarted automatically. Just spin up a new one ;)
- Sometimes removal of `destroy.sh` will fail while removing S3 resource. Running it again usually fixes the problem.