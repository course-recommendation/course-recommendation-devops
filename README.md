## Login to Azure

```bash
az login
```

Sign in with:

- **Email:** `22120374@student.hcmus.edu.vn`

```bash
az account set --subscription "Azure for Students"
export ARM_SUBSCRIPTION_ID=b14aa354-ac04-4999-bbc6-0e2d08f5bc3f
```

## Run Terraform

```bash
terraform plan -out plan -var-file=var_secret.tfvars
```