# Infrastructure Automation
The directories here specify desired infrastructure state in digital ocean.

## Running
### Terraform
Terraform needs to be install. Terraform v0.13.1 was used during the creation
and testing of this repo. 

### Environment
The following environment variables are required to be exported:
  - `DIGITALOCEAN_ACCESS_TOKEN`
  - `SPACES_ACCESS_KEY_ID`
  - `SPACES_SECRET_ACCESS_KEY`

These values can be got from your digitalocean account and are necessary to
access the digitalocean resources for your account and set up remote state for
terraform.

### Directory
Each directory containing `*.tf` files is a separate terraform project. All projects
rely on the project in the `base` directory to be up-to-date. Each of the following
commands must be run with one of these directories as the working directory.

#### init
```Bash
    <dir> $ terraform init -backend-config="access_key=$SPACES_ACCESS_TOKEN" -backend-config="secret_key=$SPACES_SECRET_KEY"
```
This creates the basis for all other environments, since all other environment
will use the same container registry, domain and a shared spaces bucket.

#### plan
```Bash
    <dir> $ terraform plan
```

#### apply
```Bash
terraform apply -auto-approve
```

