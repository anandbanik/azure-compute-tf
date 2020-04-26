# Azure Terraform for Compute VM's.

## Pre-requisite
1. Azure CLI
2. Terraform CLI
3. Azure Subscription.

## Pre-Deployment Steps
1. Clone the repository
2. Create a file called ``` terraform.tfvars``` and copy the contents of ```terraform.tfref```
3. Generate a private & public key and add that to ``` terraform.tfvars```
4. Add the details left blank in the terraform.tfvars file.

## Deployment
1. Execute ``` terraform init```
2. Execute ``` terraform plan ``` and check the output plan.
3. Execute ``` terraform apply -auto-approve ``` 
4. Login/SSH to the VM using the output Public IP.
