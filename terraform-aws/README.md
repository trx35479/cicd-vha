# Terraform module
.
├── createImage
│   ├── backend.tf
│   └── createImage.tf
├── files
│   └── dslave.pub
├── main
│   ├── backend.tf
│   ├── datasources.tf
│   ├── output.tf
│   ├── provider.tf
│   ├── provisioner.tf
│   ├── resources.tf
│   └── variables.tf
├── modules
│   ├── ec2
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   └── rds
│       ├── main.tf
│       ├── output.tf
│       └── variables.tf
├── README.md
├── slaveprofile
│   ├── backend.tf
│   └── dslaveRole.tf
├── story
│   ├── backend.tf
│   ├── datasources.tf -> ../main/datasources.tf
│   ├── provider.tf
│   ├── resource.tf
│   └── variables.tf
└── templates
    └── create_tables.sql

# Applying the terraform modules for VHA

# oracle DB name, username and password can be included as an ad-hoc variables, otherwise the default value will be used. 
- Export AWS
- Initialize all terraform modules

cd main && terraform init

- Below will override the variables for database name, username (schema) and password (below is only example variable)

terraform plan --var="DATABASE_NAME=VHA" --var="DB_USERNAME=ocsia" --var="DB_PASSWORD=nopassword" -out=vha_plan

- Below will use the default value in variables. (schema_name=ocsia, password=nopassword, dbname=VHA)

terraform plan -out=vha_plan.out

- Deploy the output of the plan

terraform apply vha_plan.out -auto-approve

- Destroy the all the resources 

terraform destroy --var="DATABASE_NAME=VHA" --var="DB_USERNAME=ocsia" --var="DB_PASSWORD=nopassword" -auto-approve

- Destroy command if the default variables was used instead

terraform destroy -auto-approve

# To deploy the story resource

- Initialize all terraform modules

cd story && terraform init

- Create a detailed plan of the resources

terraform plan -out=story_plan.out

- Deploy the plan

terraform apply -out=story_plan.out -auto-approve

- Destroy the resources

terraform destroy -auto-approve
