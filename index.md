---
title: Overview
layout: home
nav_order: 1
---

# Lab: Java and AI

In this lab, you’ll learn how to deploy intelligent Java applications to [Azure Container Apps](https://learn.microsoft.com/azure/container-apps/overview) and integrate them with additional Azure services. You’ll also deploy a copy of the Spring Petclinic sample workload to find out how Azure Container Apps supports Azure Spring Apps that use managed components.

## What you’ll cover

As you work through the lab modules, you’ll explore the following:

* A general introduction to the sample workload, the Spring applications that it’s composed of, and the related Azure services and resources you’ll use to deploy it
* A walk-through on how to deploy the [Spring Petclinic](https://github.com/spring-petclinic/spring-petclinic-microservices) workload to Azure Container Apps
* Detailed steps on enabling monitoring, end-to-end tracing, and Grafana dashboards for the deployed sample application
* Instructions on how to securely connect applications and services by using managed identities
* A walk-through on how to build intelligent Azure Spring Apps with Azure OpenAI Service
* Instructions for automatically deploying applications to Azure
* Guidance on building reliable Java apps on Azure Container Apps

You can review the contents of this lab as GitHub pages at the [Java on ACA](https://azure-samples.github.io/java-on-aca/) site.

## Getting Started

### Prerequisites

To run this lab, you’ll need:

* A GitHub account.
* An Azure subscription that grants you resource creation rights.

### Region availability

1.  This lab uses [Azure OpenAI Service](https://learn.microsoft.com/azure/ai-services/openai/overview). It also employs the **gpt-4o** and **text-embedding-ada-002** models, which are not available in all Azure regions. Before deploying any resources or selecting a region, make sure to check for [up-to-date region availability](https://learn.microsoft.com/azure/ai-services/openai/concepts/models#standard-deployment-model-availability) and for access to both models.
2.  This lab also uses [Azure Database for MySQL - Flexible Server](https://learn.microsoft.com/azure/mysql/flexible-server/overview). Before deploying or selecting a region, be sure to [verify the service is available](https://learn.microsoft.com/en-us/azure/mysql/flexible-server/overview#azure-regions) in that region.

    {: .note }
    > - At the time of publishing (January 2025), we recommend using any of the following regions to help ensure that required features are available: **East Asia**, **Australia East**, **Brazil South**, **South India**, **Japan East**, **Sweden Central**, **East US 2** and **West US**.
    > - If you encounter SKU or quota issues when attempting to create resources during any of these labs, feel free to create the resource in another one of these recommended regions.

### Installation

Before running this lab, be sure that all the required tooling is available. We’ve provided three options:

* [Use GitHub Codespaces (preferred)]({% link install.md %}#use-github-codespaces-strongly-recommended), which will create a cloud-based development environment with the required tools installed and configured.
* [Use Visual Studio Code with remote containers option]({% link install.md %}#optional-use-visual-studio-code-with-remote-containers), which will create a Docker container on your local machine with the required tools preconfigured.
* [Install all the tools on your local machine]({% link install.md %}#optional-install-all-the-tools-on-your-local-machine-not-recommended).

We’ve tested this lab using GitHub Codespaces, which is the recommended option for running it.

After the tooling is set up, you'll need to perform some steps to [prepare your subscription]({% link install.md %}#configure-your-subscription-and-deploy-prerequisite-azure-resources) before continuing with the labs.

You can find the full installation guidance and the options for running this lab in the [Installation]({% link install.md %}) instructions.
