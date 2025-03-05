---
title: Install
layout: home
nav_order: 2
---

# Installation

{: .no_toc }

Before you begin working through the lab, you’ll need to make sure that you have all the required tools installed and configured in your development environment. Additionally, in this same environment, before you start the process of deploying to Azure, you’ll need to have cloned a copy of the example Spring Petclinic workload code from the GitHub repo.

There are three options for setting up your development environment. You'll want to choose *only one* of the following:

- [Use GitHub Codespaces (strongly recommended)](#use-github-codespaces-strongly-recommended)
- [Use Visual Studio Code with remote containers](#optional-use-visual-studio-code-with-remote-containers)
- [Install all the tools on your local machine (not recommended)](#optional-install-all-the-tools-on-your-local-machine-not-recommended)

These dev environment setup tasks can take several minutes to complete, so we suggest starting this process as soon as possible. 

{: .important }
> We’ve tested all the steps of this lab in [GitHub Codespaces](#use-github-codespaces), which is the simplest way to get going and the preferred option for running the lab. Support for the alternative options during the lab may be limited. Use a Codespace if at all possible. 

As soon as you've set up your dev environment, you'll need to run a preparation script. This will save us time by performing some required configuration on your subscription and automating many of the Azure resources you'll use as part of the labs.

- [Preparing your subscription](#preparing-your-subscription)


## Use GitHub Codespaces (strongly recommended)

The [GitHub repository for this lab](https://github.com/Azure-Samples/java-on-aca) contains a devcontainer.json file configured for Java development. If your account is enabled for [GitHub Codespaces](https://github.com/features/codespaces), you can use this file to create a cloud development environment that contains all of the tools you’ll need to complete this lab.

This approach has the advantage of giving you a fully configured development environment without requiring any software installation or configuration on your local workstation.

To proceed with this option:

1.  Go to [this lab’s GitHub repository](https://github.com/Azure-Samples/java-on-aca), and select **Fork**.
1.  Be sure that your own username is indicated as the fork Owner.
1.  Select **Create fork**. This creates a copy (or fork) of this project in your own account.

    {: .note }
    > If you’re using a GitHub Enterprise Managed Users (EMU) account, you might not be able to fork a public repository. In that case, create a new repository with the same name, clone the original repository, add your new repository as a remote, and push to this new remote.

1.  Go to the newly forked GitHub project.
1.  Select **Code** and then select **Codespaces**.
1.  Select **Create a codespace**.

The codespace creation status is displayed in your browser window, and may take around 10 minutes to complete. After the creation process is complete, you can start using the codespace dev environment to execute the next steps in the lab.

## (Optional) Use Visual Studio Code with remote containers

If you're unable to use a Codespace, the next best solution is to use Docker and the [Visual Studio Code Dev Containers extension](https://code.visualstudio.com/docs/remote/containers) to deploy a preconfigured dev container on your local workstation. Using the same devcontainer.json file in the [Git repository of this lab](https://github.com/Azure-Samples/java-on-aca) noted in the GitHub Codespaces option, you can easily configure a Java development container that has all the tools you need to run this lab.

<details markdown="1">

<summary><b><a>Click here for instructions on how to use Visual Studio Code with remote containers</a></b></summary>
    
The [git repository of this lab](https://github.com/Azure-Samples/java-on-aca) includes a dev container for Java development. This container has all the tools you need to run this lab. 

This type of containerized approach allows you to quickly deploy a ready-to-use development environment. However, unlike with the GitHub Codespaces option, you need to perform the following tasks to get this working on your local workstation:

- Install [Visual Studio Code](https://code.visualstudio.com/download).
- Install [Git for Windows](https://git-scm.com/downloads) or the equivalent, if your local workstation is running another operating system.

    {: .note}
    > If needed, reinstall Git and, during installation, verify that the Git Credential Manager is enabled.

    {: .note }
    > After installing Git, run the following commands from the Git Bash shell to set the global configuration variables *user.email* and *user.name* (replace the *\<your-email-address\>* and *\<your-full-name\>* placeholders with your email address and your full name):

    ```bash
    git config --global user.email "<your-email-address>"
    git config --global user.name "<your-full-name>"
    ```

- Install the [Visual Studio Code Remote Containers extension](https://code.visualstudio.com/docs/remote/containers).
- Install [Docker](https://docs.docker.com/get-docker/).

To get started working in the dev container:

1.  Go to [this lab’s GitHub repository](https://github.com/Azure-Samples/java-on-aca), and select **Fork**.
1.  Be sure that your own username is indicated as the fork Owner.
1.  Select **Create fork**. This creates a copy (or fork) of this project in your own account.

    {: .note }
    > If you’re using a GitHub Enterprise Managed Users (EMU) account, you might not be able to fork a public repository. In that case, create a new repository with the same name, clone the original repository, add your new repository as a remote, and push to this new remote.

1.  On your lab computer, using a command line window, run the following commands to clone your fork of the spring-petclinic-microservices project to your workstation. Make sure to replace *\<your-github-account\>* in the following command:

    ```bash
    mkdir workspaces
    cd workspaces
    git clone https://github.com/\<your-github-account\>/java-on-aca.git
    ```

1.  When prompted to sign in to GitHub, select **Sign in with your browser**. This will automatically open a new tab in the web browser window, prompting you to provide your GitHub username and password.
1.  In the browser window, enter your GitHub credentials and select **Sign in**. After you’ve successfully signed in, close the newly opened browser tab.
1.  In your workspaces folder, verify that the spring-petclinic-microservices application got cloned correctly. You can use this local copy of the repository to regularly push changes back to your fork on GitHub.

    {: .note }
    > In later lab steps, you’ll put a GitHub PAT (Personal Access Token) in one of the configuration files. Make sure you **do not** commit this PAT, since it will immediately get invalidated by GitHub and your next lab steps will fail. To recover from this, refer to the [LabTips]({% link tips.md %}).

1.  Go to the java-on-aca folder where you cloned the project, and open the project with Visual Studio Code.

    ```bash
    mkdir workspaces
    cd workspaces
    git clone https://github.com/<your-github-account>/java-on-aca.git
    ```

1.  With the [Visual Studio Code Remote Containers extension](https://code.visualstudio.com/docs/remote/containers) installed, you can now open the project in a remote container. This will reopen the project in a Docker container with all the tooling installed.

After you have the Docker container open, you can start executing the rest of the lab.

</details>

## (Optional) Install all the tools on your local machine (not recommended)

If you’re unable to use either GitHub Codespaces or the Visual Studio Code Dev Containers extension, you can configure your local workstation as your development environment. To do so, you must install all the Java and Azure tools that you need to use in this lab.

{: .note }
> Only use this option if you feel comfortable installing a lot of tooling on your local workstation. Also note that it’s impossible for us to test all lab steps with all possible local configurations. We highly recommend using either the GitHub Codespaces or the Visual Studio Code Dev Containers option for running this lab.

<details markdown="1">

<summary><b><a>Click here for instructions on how to user install the required tools locally.</a></b></summary>

{: .note }
> The following guidance assumes that you’re using a Windows workstation. If your workstation is running an alternative operating system, you’ll likely need to adjust the instructions to be sure that all components are properly installed on your machine. Again, only proceed with this option if you’re comfortable configuring a Java development environment on your operating system.

Your workstation should have the following components installed:

- [Visual Studio Code](https://code.visualstudio.com/download)
    - [Java and Spring Boot Visual Studio Code extension packs](https://code.visualstudio.com/docs/java/extensions)
- [Git for Windows](https://git-scm.com/downloads) or the equivalent, if your workstation is running another operating system.

    {: .note}
    > If needed, reinstall Git and, during installation, be sure that the Git Credential Manager is enabled.

    {: .note }
    > After installing Git, run the following commands from the Git Bash shell to set the global configuration variables *user.email* and *user.name* (replace the *\<your-email-address\>* and *\<your-full-name\>* placeholders with your email address and your full name):

   ```bash
   git config --global user.email "<your-email-address>"
   git config --global user.name "<your-full-name>"
   ```

- Apache Maven 3.9.9

    {: .note }
    > To install Apache Maven, extract the content of the .zip file by running unzip apache-maven-3.9.9-bin.zip. Next, add the path to the bin directory of the extracted content to the *PATH* environment variable. Assuming that you extracted the content directly into your home directory, you could accomplish this by running the following command from the Git Bash shell: *export PATH=\~/apache-maven-3.9.9/bin:\$PATH*.

- [Java 17 and the Java Development Kit (JDK)](https://aka.ms/download-jdk/microsoft-jdk-17.0.13-windows-x64.msi)

    {: .note }
    > To install the JDK on Windows, follow the instructions provided in the [JDK Installation Guide](https://learn.microsoft.com/java/openjdk/install#install-on-windows). Make sure to use the *FeatureJavaHome* feature during the install to update the *JAVA_HOME* environment variable.

- Install [Azure CLI version 2.60.0 or later](https://learn.microsoft.com/cli/azure/install-azure-cli-linux?pivots=apt#install-azure-cli).

After all these tools are installed, you can get started:

1.  Go to [this lab’s GitHub repository](https://github.com/Azure-Samples/java-on-aca), and select **Fork**.
1.  Be sure that your own username is indicated as the fork Owner.
1.  Select **Create fork**. This creates a copy (or fork) of this project in your own account.

    {: .note }
    > If you’re using a GitHub Enterprise Managed Users (EMU) account, you might not be able to fork a public repository. In that case, create a new repository with the same name, clone the original repository, add your new repository as a remote, and push to this new remote.

1.  On your lab computer, in the Git Bash shell, run the following commands to clone your fork of the *spring-petclinic-microservices* project to your workstation. Make sure to replace \<your-github-account\> in the following command:

    ```bash
    mkdir workspaces
    cd workspaces
    git clone https://github.com/<your-github-account>/java-on-aca.git
    ```

1.  When prompted to sign in to GitHub, select **Sign in with your browser**. This will automatically open a new tab in the web browser window, prompting you to provide your GitHub username and password..
1.  In the browser window, enter your GitHub credentials and select **Sign in**. After you’ve signed in successfully, close the newly opened browser tab.
1.  In your workspaces folder, verify that the spring-petclinic-microservices application was cloned correctly. You can use this local copy of the repository to regularly push changes to your fork on GitHub.
1.  Go to the java-on-aca folder where you cloned the project, and open the project with Visual Studio Code.

    ```bash
    cd java-on-aca
    code .
    ```
</details>

## Preparing your subscription

With your development environment set up, you're now going to use some scripts to perform some subscription configuration and also deploy some Azure resources that you'll use during the labs. 


{: .note }
We'll be using Bash commands to complete this lab. You can use any compatible command-line environment, such as the Windows Subsystem for Linux, Git Bash, or the Visual Studio Code Bash terminal. To avoid potential errors, **do not** attempt to run these commands in a PowerShell session.

### Sign into Azure

Before you run the scripts, you'll need to sign in to Azure and configure it to access your lab subscription.

1.  In your lab environment, open a command-line environment and sign in to your Azure subscription with the following command:

    ```bash
    az login
    ```

    {: .note }
    > If you’re running this lab in GitHub Codespaces, use az login --use-device-code.

    When you execute the command, it automatically opens a web browser window and requires that you sign in. When prompted, sign in using a user account that has the Owner role in your lab subscription. Once you've finished signing in you can close the browser window.

1.  Run the following command to list the subscriptions you have access to:

    ```bash
    az account list -o table
    ```

    If you don't see the lab subscription listed as your default one, use the following command to set it (replace \<*subscription-id*\> with the lab subscription’s ID):

    ```bash
    az account set --subscription <subscription-id>
    ```

### Run the subscription preparation script

Now you'll run the script `prepare.sh` to register the required resources providers on your lab subscription, and also add any necessary extensions to the Azure CLI.

1.  In your command line windows, go to the root of the `java-on-aca` folder and run the script `./tools/prepare.sh`.

    ```bash
    ./tools/prepare.sh
    ```

    This process should take less than 10 minutes to complete. 

1. Once the `prepare.sh` script finishes, close your current terminal window and start a new terminal session to access your fully prepared lab environment.

### Run the resource creation script

You'll now need to run the script `create-azure-resource.sh`, which will create several of the Azure resource dependencies that you'll use in the labs.

1.  Before running the script, you'll need to edit the file `./tools/azure-resource.profile` in a code editor and update the following values:

    - `UNIQUEID` - Create a unique ID string and paste that in the code editor. You can use the following command generate an acceptable value: `openssl rand -hex 3`
    - `SUBSCRIPTION` - Enter the ID of the subscription you're going to work in. To quickly find this id, use the following command: `az account show --query id`
    - `REGION` -  Enter the default Azure region you want to work in. For example `westus` or `southindia`.
    - `MYSQL_ADMIN_PASSWORD` - enter a strong password string. 

    After setting these values, save the updated `azure-resource.profile` file before proceeding.

1.  Run the script `./tools/create-azure-resource.sh` to start creating the required lab resources.

    ```bash
    ./tools/create-azure-resource.sh
    ```

    This script should take around 10 minutes to complete and will deploy the following resource types:

    - [Azure Database for MySQL - Flexible Server](https://learn.microsoft.com/azure/mysql/flexible-server/overview)
    - [Azure Container Registry](https://learn.microsoft.com/azure/container-registry/container-registry-intro)
    - [Azure OpenAI Service](https://learn.microsoft.com/azure/ai-services/openai/)
    - [Log Analytics workspace](https://learn.microsoft.com/azure/azure-monitor/logs/log-analytics-workspace-overview)
    - [Application Insights](https://learn.microsoft.com/azure/azure-monitor/app/app-insights-overview)
    - [Azure Managed Grafana](https://learn.microsoft.com/azure/managed-grafana/)

    If you encounter errors, double check that you've provided the correct values in the `azure-resource.profile` file, and then try to rerun the script.

    While you'll need this script to finish before you can start Lab 2, feel free to start Lab 1 while you wait. 


{: .important }
> The actions you just performed are fundamental, so please do not delete any of the resources you've created here until you've completely finished all labs.
>
>In addition to those resources, you've also defined important environment variables that you'll use throughout these labs. To make sure you don't lose these variables after closing your current bash session, you'll want to save them.
>
> Before you do anything else, run the command `saveenv` in your open command-line window. This will save all of your currently defined environment variables to the file `~/.dev-environment`. The next time you start a new bash session you will automatically load the saved variables from this file.
>
> You can also manually load the saved variables with the command `loadenv`. 
> 
> You can use these commands at any time, so feel free to run `saveenv` after creating or updating environment variables when working through the labs, or `loadenv` to reload your saved variables as needed. 
