---
title: 'Lab tips and troubleshooting'
layout: home
nav_order: 99
---

# Tips for best results with the lab
{: .no_toc }

Tips in this section include:

- TOC
{:toc}

## Use GitHub Codespaces

As described in the [installation instructions]({% link install.md %}), the best and easiest way to run this lab is to use [GitHub Codespaces](https://github.com/features/codespaces). With the devcontainer.json file provided in the lab's [GitHub repository](https://github.com/Azure-Samples/java-on-aca) you can create a codespace that has the required tools pre-installed and configured for you. The steps in this lab have been thoroughly tested with the codespace configuration included in the repo.

If you're unable to use a codespace, the best alternative is Visual Studio Code with remote containers, which allows you to deploy and work with a preconfigured Docker development environment.

If you can't use either of these options, you can complete this lab by installing the required tooling on your local environment. However, since it’s impossible for us to test all lab steps with every possible local configuration, we highly recommend using either GitHub Codespaces or the Visual Studio Code with remote containers.

## Use .azcli files to make command line work easier

If you're using Visual Studio Code, you can record the command-line statements that you execute in a file with the _.azcli_ extension. This extension, combined with the [Azure CLI Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.azurecli) extension, gives you extra capabilities, like IntelliSense, and the opportunity to directly run statements from the script file in a terminal window.

With this extension, you can keep a record in an .azcli file of all the steps that you executed and quickly execute these statements through the `Ctrl+` shortcut. To save time and effort in this lab, be sure to check out the extension.

## Troubleshoot issues

There are a couple places in the lab where you can easily to miss steps or incorrectly execute a statement. If you run into errors as a result,  try the following debug steps:

1.	Carefully recheck the lab instructions to make sure that you executed each step.

1.	Confirm that all YAML is correctly indented and lacks formatting errors.

1.	Check to ensure that you saved all the files you modified.

1.	Check the logs for the failing application or service.

   ```bash
   az containerapp logs show -g $RESOURCE_GROUP -n <APP_NAME>
   ```

### Dealing with code errors

If you find coding issues that lead to errors, fix the issues and then rebuild and redeploy the affected application.

To rebuild and redeploy an application:

1. Go to the repo's src folder, and rebuild the application that contains the code you fixed.

   ```bash
   cd ~/workspaces/java-on-aca/src
   mvn clean package -DskipTests -rf :spring-petclinic-<microservice-name>
   ```

1. Update the affected container app instance.

   ```bash
   az containerapp update \
      --name $APP_NAME \
      --resource-group $RESOURCE_GROUP \
      --source ./spring-petclinic-$APP_NAME
   ```

## Work around issues when using a codespace

If you're using a codespace and running  the labs in a subscription with policies that lock down what you're allowed to do, you might encounter errors when performing certain steps. The currently known failures include:

- Not Authorized on some operations. Specifically, this can happen on operations using managed identities and Azure Key Vault, where policy settings on the subscription prevent you from running them from a codespace.

To recover from this issue, re-execute the failed step [using an Azure Cloud Shell window](https://learn.microsoft.com/en-us/azure/cloud-shell/using-the-shell-window).


## Persist environment variables in a codespace

When you use  a codespace to run this lab, your environment variables will be lost if the codespace restarts. To avoid this issue, follow [GitHub's guidance on persisting variables](https://docs.github.com/en/enterprise-cloud@latest/codespaces/developing-in-codespaces/persisting-environment-variables-and-temporary-files). We recommend the [single codespace](https://docs.github.com/en/enterprise-cloud@latest/codespaces/developing-in-codespaces/persisting-environment-variables-and-temporary-files#for-a-single-codespace) approach, since it's the easiest to set up and doesn't require a workspace restart.

The help you get started with this method, you can find a [samplebashrc file](https://github.com/Azure-Samples/java-on-aca/blob/main/solution/samplebashrc) in the lab's repository. Before proceeding, you'll need to update this file with the relevant unique values for your environment before proceeding.

Another approach would be to create a dedicated .azcli file to keep your environment variables. After a workspace restart, you first rerun all the steps in this file and then you can proceed. If you’d like to try this approach, you can find a [sampleENVIRONMENT.azcli file](https://github.com/Azure-Samples/java-on-aca/blob/main/solution/sampleENVIRONMENT.azcli) file in this repository, which you’ll need to update with the relevant values for your environment before using.
