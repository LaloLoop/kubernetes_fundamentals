# Kubernetes Fundamentals (LFS258)

This repository contains the necessary infrastructure to run the labs in the LFS258 course.

## Requirements

* GCP account
* Terraform Cloud account
* GCP project (manually set as not organization will be created)

## Setup

### GCP project

Set up a new GCP project for the course, in this case I will be calling it `LFS258`.

1. Click on the projects list in the upper menu bar
2. Click on new project
3. Fill in the name as shown in the image below

![new-gcp-project](imgs/01_gcp_project.png)

### Service account

Create a service account for Terraform, which will have admin permissions in order to be able to provision the various resources we will be using.

1. Go to IAM & Admin.
2. Click on Service Accounts.
3. Click con Create Service Account.
4. Fill in the name and description as shown in the image below.

![service-account](imgs/02_service_account.png)

Set up the permissions, give it permission to only those APIs that will be needed, in this case:

* Compute Engine Administrator: To create VMs, admin VPCs, subnets, etc.
* Service Usage Admin: To enable GCP APIs.

![sa-roles](imgs/03_sa_roles.png)

Finally click Done.

### Access Key

Create a new Access Key for the service account.

1. Go to IAM & Admin
2. Click on Service Accounts
3. Click on the three dots on the far right of the service account you created in the last section.
4. Click on Create Account
5. Choose JSON and click Create.

![sa-create-key](imgs/04_create_key.png)
![sa-json-key](imgs/05_json_key.png)

### Enable Cloud Resource Manager API

This script will attempt to enable the Cloud Resource Manager API, but it may need some manual help.

1. Go to API & Services.
2. Click con Enable APIs and Services.
3. Search for Cloud Resource Manager API.
4. Enable it.

Once manually enabled, you can import it with the following command.

```bash
terraform import google_project_service.cloud_resource_manager_api <project-id>/cloudresourcemanager.googleapis.com
```

### Configure Terraform Cloud

This assumes you have created a Terraform Cloud (TC) account and organization.

Create a workspace as specified in [this Terraform documentation](https://learn.hashicorp.com/tutorials/terraform/cloud-workspace-create?in=terraform/cloud-get-started).

Configure the json key you generated in the last section:

1. Open it with your favorite editor.
2. Replace the new line characters for an empty string: You can do this in Visual Studio Code by searching the new line character (Ctrl+Enter) and replace it by nothing (empty string).
3. Copy the file content.
4. Create the `GOOGLE_CREDENTIALS` variable in you TC workspace as described in [this article](https://learn.hashicorp.com/tutorials/terraform/cloud-workspace-configure?in=terraform/cloud-get-started), mark the *Sensitive* checkbox.

Configure the SSH public key as variable, generate an SSH key with the following command:

```bash
ssh-keygen -C student
```

Set `./id_rsa` as the destination location, this should pick up your pub key with the default `./id_rsa.pub` file, if you want to change this, modify the `gce_ssh_pub_key_file` variable.

You can connect to the machines once they are provisioned with the following command.

```bash
ssh -i id_rsa student@<public-up>
```

## Applying changes

Queue a plan in terraform with the resources available in this repository.

## Cleaning up

Queue a destroy plan inside Terraform Cloud's Settings > Destruction and Deletion, this won't disable the enable APIs for faster provisioning the second time you run this, which will help you save by not having to run everything 24/7 until you complete the course.

## TODOs

* [ ] Add sudo configuration.
* [ ] Add extra configurations based on course content.
