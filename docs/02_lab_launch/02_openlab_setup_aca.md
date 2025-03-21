---
title: 'Lab 2: Deploy applications to Azure Container Apps'
layout: default
nav_order: 4
has_children: true
---

# Lab 02: Deploy the applications to Azure Container Apps

## Introduction

In the previous lab, you reviewed the sample Spring Petclinic workload that you’ll deploy, examined the Azure services that the component Spring applications will rely on, and made sure that the necessary tooling is configured and ready in your development environment. Now it’s time to deploy the workload to an Azure Container Apps instance.

## What you’ll cover

As you work through this lab, you’ll learn how to:

-   Create an Azure Container Apps environment.
-   Create an Azure Database for MySQL instance.
-   Set up a configuration repository.
-   Create the required managed Java components.
-   Deploy the workload's component applications to the Azure Container Apps environment and bind them to the managed Java components.
-   Test the deployed applications through the publicly available endpoint.

The following image shows how your workload's architecture should look once you complete this lab.

![lab 2 overview](../../images/acalab2.png)

## Duration

**Estimated time:** 60 minutes

{: .note }
> The [Azure-Samples/java-on-aca](https://github.com/Azure-Samples/java-on-aca/) repository contains a dev container for Java development, and it has all the tools for running this lab. If you want to use this dev container, you can do so via either [GitHub Codespaces](https://github.com/features/codespaces) (if your GitHub account is enabled for Codespaces) or the [Visual Studio Code Remote Containers](https://code.visualstudio.com/docs/remote/containers) option. You can find the setup steps in the [Installation instructions]({% link install.md %}).
