## Web application DevOps pipeline using EKS and Github actions

+ webapp folder - Express.js API application and dockerfile for generating an image. This image will be used in Helm Chart
+ webappchart folder - Helm chart for deploying Express.js API application with mysql database on existing EKS cluster
+ .github/workflows folder
  +  publish_ecr.yml - Publish images to Amazon ECR public repository. This workflow will be triggered on a successful merge into main branch
  +  deploy_webapp.yml - Deploy infrastructure using terraform. This workflow will be triggerred on successful completion of publish_ecr workflow
+  main.tf - Infrastructure required for EKS cluster. Creation of VPC and configuring S3 remote backend
+  output.tf - Terraform output providing EKS cluster details and cluster endpoint
+  webapp-dev-eks.tf - Deploy EKS cluster with one AWS managed worker node
+  helm_release.tf - Deploy application helm chart from webappchart folder on existing EKS cluster
+  tf_apply.sh - Bash script to guide terraform apply command

------
### Author
+ Pratik Thakkar

------
### Instructions

##### Create Amazon S3 bucket for storing terraform state file as remote backend
##### Create Amazon DynamoDB table for state locking mechanism
##### Update terraform backend mechanism in main.tf with S3 bucket name and DynamoDB table name
```
terraform {
  backend "s3" {
    bucket         = "<S3 bucket name>"
    key            = "terraform.tfstate"
    region         = "<S3 bucket and DynamoDB region>"
    dynamodb_table = "<DynamoDB table name>"
    encrypt        = true
  }
}
```
##### Store an IAM user access key in GitHub Actions secrets named 'AWS_ACCESS_KEY_ID' and 'AWS_SECRET_ACCESS_KEY'
##### Create a branch and update the settings as per requirement. Create pull request and merge it. Github workflow will be triggered on successful merge with main branch

------
### Demo

https://user-images.githubusercontent.com/17193500/170867531-5ee2895a-4780-4f91-beed-7e36cd33d22e.mp4

------

