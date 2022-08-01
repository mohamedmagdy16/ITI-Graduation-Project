# Provision infrastructure on GCP
1. Create a GCP project
2. Clone repo 
3. edit project_id in infrastructure.tfvars with your project id and edit provider configuration 


# provision the infrastructure on GCP
```bash
# initialize terraform
terraform init

# check plan
terraform plan --var-file infrastructure.tfvars

# applying the plan 
terraform apply --var-file infrastructure.tfvars
