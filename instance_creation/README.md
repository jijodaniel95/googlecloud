# Google Cloud Instance Creation with Terraform

This directory contains the necessary files to create a Google Cloud Compute Engine instance using Terraform. This guide will walk you through the setup, configuration, and deployment steps.

## 1. Prerequisites

Before you begin, ensure you have the following tools installed and configured:

*   **Homebrew (for macOS users)**:
    Homebrew is a package manager for macOS. If you don't have it, you can install it by following the instructions on its official website: [https://brew.sh/](https://brew.sh/).

*   **Google Cloud SDK**:
    The Google Cloud SDK provides the `gcloud` command-line tool, which is essential for authenticating with Google Cloud.
    *   **Installation**: Install it using Homebrew:
        ```bash
        brew install --cask google-cloud-sdk
        ```
    *   **Authentication**: After installation, you need to authenticate your `gcloud` environment and set up application default credentials (ADCs) that Terraform can use:
        ```bash
        gcloud auth login
        gcloud auth application-default login
        ```
        Follow the prompts in your browser to complete the authentication process.

*   **Terraform**:
    Terraform is an Infrastructure as Code (IaC) tool used to define and provision infrastructure.
    *   **Installation**: Install it using Homebrew:
        ```bash
        brew install terraform
        ```

## 2. Project Files

This project relies on two main Terraform configuration files:

*   `main.tf`: This is the primary Terraform configuration file. It defines the Google Compute Engine instance (e.g., its name, machine type, boot disk, and network interface). It uses variables for flexible configuration.

*   `terraform.tfvars`: This file holds specific values for the variables defined in `main.tf`. This includes your Google Cloud `project_id`, the desired `region`, and `zone` for your instance.
    *   **Example `terraform.tfvars` content (ensure your `project_id` is correct):**
        ```terraform
        project_id = "your-google-cloud-project-id"
        region     = "us-central1"
        zone       = "us-central1-c"
        ```
    *   **Important**: If this file is missing or deleted, you must recreate it with your specific project details.

## 3. Getting Started & Deploying Infrastructure

Follow these steps to initialize your Terraform environment and deploy your Google Cloud instance:

1.  **Navigate to the Project Directory**:
    Ensure your terminal is in the `instance_creation` directory (e.g., `/Users/jijodaniel/projects/googlecloud/instance_creation`).

2.  **Initialize Terraform**:
    This command initializes the Terraform working directory, downloads the necessary Google Cloud provider plugin, and sets up the backend.
    ```bash
    terraform init
    ```

3.  **Review the Execution Plan**:
    This command generates an execution plan that shows you exactly what actions Terraform will take to create or modify your infrastructure, based on `main.tf` and the variables in `terraform.tfvars`.
    ```bash
    terraform plan -var-file="terraform.tfvars"
    ```
    Review the output carefully to ensure it matches your expectations.

4.  **Apply the Configuration**:
    Once you are satisfied with the plan, this command will apply the changes defined in the plan to your Google Cloud project, creating the compute instance.
    ```bash
    terraform apply -var-file="terraform.tfvars"
    ```
    Terraform will prompt you to confirm the actions. Type `yes` and press Enter to proceed.

## 4. Troubleshooting Tips

*   **"command not found: terraform" or "command not found: gcloud"**: This means Terraform or Google Cloud SDK is not installed or not in your system's PATH. Re-run the installation steps in the Prerequisites section.
*   **Authentication Errors ("No credentials loaded")**: Ensure you have successfully run both `gcloud auth login` and `gcloud auth application-default login`. You can check your active credentials with `gcloud auth list`.
*   **Syntax Errors in `terraform.tfvars`**: Double-check your `terraform.tfvars` file for missing quotes, commas, or incorrect formatting. Terraform's HCL syntax is strict.
*   **Missing `terraform.tfvars`**: If you deleted this file, recreate it with your `project_id`, `region`, and `zone` as shown in the "Project Files" section.
*   **Refer to Official Documentation**: For more detailed information or complex issues, consult the official [Terraform documentation](https://www.terraform.io/docs) and [Google Cloud documentation](https://cloud.google.com/docs).

Let me know if you want me to proceed with this update to your `instance_creation/README.md` file.