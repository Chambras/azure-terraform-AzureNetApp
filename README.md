# Azure NetApp Files

Simple Terraform script that creates the initial setup to start using Azure NetApp Files
It creates the following resources:

* A new Resource Group.
* A CentOs VM.
* A VNet and 2 subnets.
* A Network Security Group with SSH, HTTP and RDP access.
* A NetApp Account.
* A NetApp Capacity Pool.
* A delegated NetApp subnet.

It should be easy to reuse in order to create more Accounts and/or Pools.

The CentOS VM also deploys a web server just to show how you can automate some initial tasks or even mount the NetApp Fileshare automatically.

## Project Structure

This project has the following files which make them easy to reuse, add or remove.

```ssh
.
├── CentOSVM.tf
├── LICENSE
├── README.md
├── main.tf
├── netapp.tf
├── networking.tf
├── outputs.tf
├── security.tf
└── variables.tf
```

Most common paremeters are exposed as variables in _`variables.tf`_

## Before you begin

> [!IMPORTANT]
> You need to be granted access to the Azure NetApp Files service.  To request access to the service, see the [Azure NetApp Files waitlist submission page](https://forms.office.com/Pages/ResponsePage.aspx?id=v4j5cvGGr0GRqy180BHbR8cq17Xv9yVBtRCSlcD_gdVUNUpUWEpLNERIM1NOVzA5MzczQ0dQR1ZTSS4u).  You must wait for an official confirmation email from the Azure NetApp Files team before continuing.

## Register for Azure NetApp Files and NetApp Resource Provider

1. Specify the subscription that has been whitelisted for Azure NetApp Files:

    ```azurecli-interactive
    az account set --subscription <subscriptionId>
    ```

1. Register the Azure Resource Provider:

    ```azurecli-interactive
    az provider register --namespace Microsoft.NetApp --wait  
    ```

## Pre-requisites

It is assumed that you have azure CLI and Terraform installed and configured.
More information on this topic [here](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure). I recommend using a Service Principal with a certificate.

### versions

* Terraform =>0.12.17
* Azure provider 1.37.0
* Azure CLI 2.0.77

## Authentication

CentOS uses key based authentication and it assumes you already have a key and you can configure the path using the _sshKeyPath_ variable in _`variables.tf`_
You can create one using this command:

```ssh
ssh-keygen -t rsa -b 4096 -m PEM -C vm@mydomain.com -f ~/.ssh/vm_ssh
```

## Usage

Just run these commands to initialize terraform, get a plan and approve it to apply it.

```ssh
terraform fmt
terraform init
terraform validate
terraform plan
terraform apply
```

I also recommend using a remote state instead of a local one. You can change this configuration in _`main.tf`_
You can create a free Terraform Cloud account [here](https://app.terraform.io).

### Create a Volume

At this time Terreaform does not support creating NetApp Volumes, but you can execute this command to quickly create one. I will update this repo once Terraform supports it.

```ssh
RESOURCE_GROUP=$(terraform output | grep generic_RG | cut -d'=' -f2 | tr -d [:blank:])
LOCATION=$(az group show -g $RESOURCE_GROUP --query "location" -o tsv)
VNET_NAME=$(terraform output | grep usriMain | cut -d'=' -f2 | tr -d [:blank:])
SUBNET_NAME=$(terraform output | grep netAppSubnet | cut -d'=' -f2 | tr -d [:blank:])
VNET_ID=$(az network vnet show --resource-group $RESOURCE_GROUP --name $VNET_NAME --query "id" -o tsv)
SUBNET_ID=$(az network vnet subnet show --resource-group $RESOURCE_GROUP --vnet-name $VNET_NAME --name $SUBNET_NAME --query "id" -o tsv)

ANF_ACCOUNT_NAME=$(terraform output | grep netAppAccountName | cut -d'=' -f2 | tr -d [:blank:])
POOL_NAME=$(terraform output | grep netAppPool | cut -d'=' -f2 | tr -d [:blank:])
SERVICE_LEVEL=$(terraform output | grep serviceLevel | cut -d'=' -f2 | tr -d [:blank:])
POOL_SIZE_TiB=$(terraform output | grep poolSize | cut -d'=' -f2 | tr -d [:blank:])
VOLUME_SIZE_GiB=100 # 100 GiB
UNIQUE_FILE_PATH="myNetAppBackup" # Please note that creation token needs to be unique within subscription and region

az netappfiles volume create \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION \
    --account-name $ANF_ACCOUNT_NAME \
    --pool-name $POOL_NAME \
    --name "myBackUpVol1" \
    --service-level $SERVICE_LEVEL \
    --vnet $VNET_ID \
    --subnet $SUBNET_ID \
    --usage-threshold $VOLUME_SIZE_GiB \
    --file-path $UNIQUE_FILE_PATH \
    --protocol-types "NFSv3"
```

More information about Azure NetApps files, quickstarts, How-tos and more can be found [here.](https://docs.microsoft.com/en-us/azure/azure-netapp-files/).

> [!IMPORTANT]
> Command group 'netappfiles' is in preview. It may be changed/removed in a future release.

### Mount Volume

In order to mount the volume in CentOS you can execute the followign command:

```ssh
# Install the NFS client
sudo yum install -y nfs-utils

# Create a new directory
sudo mkdir myBackUpVol1

# Get mount target IP address
CENTOS_PRIVATE_IP=$(hostname -I)

# Mount your NFSv3 file system
sudo mount -t nfs -o rw,hard,rsize=65536,wsize=65536,vers=3,tcp $CENTOS_PRIVATE_IP:/myNetAppBackup myBackUpVol1
```

## Clean resources

Delete NetApp Volumes

```ssh
az netappfiles volume delete -g $RESOURCE_GROUP --account-name $ANF_ACCOUNT_NAME --pool-name $POOL_NAME --name myBackUpVol1

```

It will destroy everything that was created by Terraform.

```ssh
terraform destroy --force
```

## Caution

Be aware that by running this script your account might get billed.

## Authors

* Marcelo Zambrana
