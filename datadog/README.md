# Datadog eCommerce Application

This example demonstrates how to use the [Terraform Datadog
Provider](https://www.terraform.io/docs/providers/datadog/index.html)
for configuring dashboards, monitors, and tracing.

## Prerequisites

* [Datadog Account](https://app.datadoghq.com/signup)
* [HashiCorp Terraform 0.12+](https://www.terraform.io/downloads.html)
* docker-compose

### Optional: Remote Instance of eCommerce Application

If you would like to deploy an instance of the eCommerce application that
is not on your laptop, you will need:

* Google Cloud Platform account
* [HashiCorp Packer](https://www.packer.io/downloads.html)

## Deploy eCommerce Application

Locally, to deploy eCommerce application:

1. Clone the eCommerce example.
   ```shell
   git clone https://github.com/datadog/ecommerce-workshop
   ```
1. Follow the instructions in the README to create it locally.


Remotely, to deploy eCommerce application:

1. Clone this repository.

1. Build a GCP image with Docker, docker-compose, and dependencies.
   ```shell
   cd datadog/setup/packer
   ZONE=${GOOGLE_ZONE} PROJECT=${GOOGLE_PROJECT} make build
   ```
   This makes it faster to spin up the instance once it's created.

1. After the GCP image has been created, you can spin up the instance
   with Terraform. Make sure to define the Terraform variables.
   ```shell
   export TF_VAR_dd_api_key=${DATADOG_API_KEY}
   terraform init
   terraform plan
   terraform apply
   ```

1. This will create a publicly available instance that has traffic replaying
   to the application within the GCP instance. You can access the public
   endpoint of the instance by retrieving the public IP from the Terraform
   output.
   ```shell
   open http://$(terraform output ecommerce):3000
   ```

## Deploy Monitors & Dashboards for the eCommerce application

You can deploy the monitors and dashboards for the application
using Terraform.

1. Define the Datadog API and Application Key.
   ```shell
   export DATADOG_API_KEY=${DATADOG_API_KEY}
   export DATADOG_APP_KEY=${DATADOG_APP_KEY}
   cd datadog/
   ```

1. Check out `terraform.auto.tfvars` for the variable
   definitions for the ecommerce application.

1. Dry run the changes to the monitors and dashboards.
   ```shell
   cd datadog/
   terraform init
   terraform plan -var-file=terraform.auto.tfvars
   ```

1. Apply the changes to the monitors and dashboards.
   ```shell
   cd datadog/
   terraform apply -var-file=terraform.auto.tfvars
   ```

This will create a fake integration to PagerDuty,
some monitors, and a dashboard to Datadog.