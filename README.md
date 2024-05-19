# Overview
This repo contains Terrform configurations to deploy EKS cluster on AWS. The configuration allows to deploy into multiple environments. For this use case, I have use Prod and Stage for demonstration.

I have used the following Terraform modules to create the infrastructure
1. [AWS VPC](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
2. [AWS EKS](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)

## Repository Structure
I have divided the configurations into modules namely `network` and `cluster` for creating VPC and other networking resources and the cluster respectively. The IAM related resources relevant to EKS also part of `cluster` module.

Then I have described two environments `prod` and `stage` in their own directories. This allows for lose coupling between both environments.

## Run locally
To run these terraform configurations locally, You have to configure the AWS credentials with relevant permissions and a backend s3 bucket.

### Steps to run
- `git clone git@github.com:raheelkhan/infrastructure-eks.git`
- `cd infrastructure-eks`

Then you have to change directory to either `prod` or `stage` depending on which environment is the target and run the following command
```
export TFSTATE_BUCKET="your-bucket-name"
export TFSTATE_KEY="<prod/stage>/terraform.tfstate"
export TFSTATE_REGION="your-region"

terraform init \
-backend-config="bucket=${TFSTATE_BUCKET}" \
-backend-config="key=${TFSTATE_KEY}" \
-backend-config="region=${TFSTATE_REGION}"

terraform plan
terraform apply
```

This is based on the assumption that the relevant role is properly setup and the bucket is already there.

## Github OIDC
This terraform configurations actually run via Github Actions. In order to give the Github Actions access to AWS APIs, there are two ways. One is to store AWS access credentials in Github secrets and the other is to let AWS authenticate this Github repository as a Federated Identity using IAM Identity Provider (OIDC). I have chose the OIDC option as it is better than giving long live credentials to Github for AWS.

Following is the sample trust policy that is being used in this project on my personal AWS account

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::012345678910:oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                },
                "StringLike": {
                    "token.actions.githubusercontent.com:sub": "repo:raheelkhan/*:refs/heads/master"
                }
            }
        }
    ]
}
```

## Deployment Pipeline
The CI/CD pipeline for this application is written using Github Actions. It contains two flows one for CI where it performs mainly code testing and compiling. The other flow is for CD where it creates the resources in AWS such as VPC and EKS Cluster.

### Github Repository Settings
Before running the deployment pipeline the Github repo must meet the below requirements.

1. The following secrets needs to be created in the repository
    - PROD_AWS_IAM_ROLE_ARN
    - PROD_BUCKET
    - PROD_KEY
    - PROD_REGION

    - STAGE_AWS_IAM_ROLE_ARN
    - STAGE_BUCKET
    - STAGE_KEY
    - STAGE_REGION

### Decision Decison 
The decision of not using Github environments here is intentional. As you will see the `terraform-reusable-cd.yaml` file that I have configured manual approvals when terraform generates the plan. A Github Issue will be created containing the link of the artficat (A zip file containing terrafrom plan output). Once the Issue is closed based on certain predefined text `approve`, `approved`, `lgtm` and `yes` then only the apply step will run. This type of flexibilty was not achievable in Github environments. As I was only able to do the required approval on Job level.

### Continuous Integration
There is a workflow `terraform-ci.yaml` configured which listens to any PR creation or code updates that targets `master` branch. One any code change this flow runs and check for the applicaiton code. Please note that I have moved the steps related to CI (In general code health check such as testing, security scans) to its own reusable workflow in `terraform-reusable-ci.yaml` because I also need the same steps runs before actual deployment that acts on `master`.

### Continuous Deployment
The deployment is configured to run when there is a PR merged to master. It also listens to push events but we must enable branch protection for Github settings.

Since I have used reusable workflow, the first thing that runs here is also the `terraform-reusable-ci.yaml` file.

After that it starts deployment to `Stage` environment. It will run `Terraform Init` and `Terraform Plan` actions and then wait for designated approvers to approve the plan. After that it will automatically resume the process and do actual `Terraform Apply`

Notice that there is `working-directory` configured for most of the steps in the workflow file. This lets me run the same reusable flow for both `Stage` and `Prod`.

Then finally, I am outputting some relevant values such as EKS Cluster name and Endpoint so that it can be used in the actual application repository and inputs.

## AWS Load Balancer Controller
Because EKS does not provide a way to provision the `AWS Load Balancer Controller` by simply turning on / off any flag like it does for `AWS EBS CSI Driver` for example. There is a need to integrate Helm provider within the terraform configuration. Because AWS distributes the ALB Controlelr manifest as [Helm Chart](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.7/) 

I have configured this add on so that I can expose the application running in EKS via public endpoint using Application Load Balancer. 

### Some Improvements 
The configuration of EKS addons via Helm as a standard practice should be done outside of Terraform. These helm charts expects the cluster should be reachable already. In my case, I have put it within the Terraform configuration because of time constraints. In real life projects this should be avoided. 
