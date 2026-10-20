# This is developed by Mahesh Chittibonu.

# IBM Cloud Pak for Business Automation (CP4BA) with BAW on Azure ARO

This repository provides an automated Infrastructure-as-Code (Terraform) blueprint to deploy IBM Cloud Pak for Business Automation (CP4BA) featuring **Business Automation Workflow (BAW)** on an **Azure Red Hat OpenShift (ARO)** cluster.

## Prerequisites
* Terraform (v1.5+)
* Azure CLI authenticated with administrative permissions
* OpenShift CLI (`oc`)
* IBM Entitlement Key

## Quick Start
1. Extract the repository zip file and navigate into the folder.
2. Create a `terraform.tfvars` file:
   ```hcl
   ibm_entitlement_key = "YOUR_IBM_ENTITLEMENT_KEY"
   openshift_token     = "YOUR_OCP_TOKEN"
   db_connection_url   = "jdbc:postgresql://..."
   ```
3. Initialize and deploy:
   ```bash
   terraform init
   terraform apply
   ```
