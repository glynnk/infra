# K8s Infrastructure
See [the infra-modules repo](https://github.com/glynnk/infra-modules) for information on what's going on here.


## Running
### Terraform
Terraform needs to be install. Terraform v0.13.1 was used during the creation
and testing of this repo. 

### Environment
The following environment variables are required to be exported:
  - `DIGITALOCEAN_ACCESS_TOKEN`
  - `SPACES_ACCESS_KEY_ID`
  - `SPACES_SECRET_ACCESS_KEY`
  - `TF_VAR_do_access_token=$DIGITALOCEAN_ACCESS_TOKEN` 

These values can be got from your digitalocean account and are necessary to
access the digitalocean resources for your account and set up remote state for
terraform.

### Directory
Ensure that the 'main' infrastructre' is provisioned before provisioning the
'dev' infrastructure. Issue the following commands from either directory.
 
#### init
```Bash
    <dir> $ terraform init -backend-config="access_key=$SPACES_ACCESS_TOKEN" -backend-config="secret_key=$SPACES_SECRET_KEY"
```

#### plan - see what infrastructure would be provisioned on digitlocean.com if you *apply*
```Bash
    <dir> $ terraform plan
```

#### apply - apply changes to digitalocean.com
```Bash
    <dir> $ terraform apply -auto-approve
```

#### destroy - tear down the provisioned infrastructure on digitalocean.com
```Bash
    <dir> $ terraform destroy -auto-approve
```
