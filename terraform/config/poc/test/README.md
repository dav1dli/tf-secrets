Thus, if project=poc, environment=test executed commands are:
```
az account set --subscription d7d0b744-7dd4-494d-b357-0e13c93cf89e
```
Run environment variables example:
```
cd terraform/envvar
export TF_VAR_password=$(az keyvault secret show -n pg-admin-password \
   --vault-name ${KV_NAME} --query value -o tsv)
terraform init -var-file=../config/poc/test/terraform.tfvars
terraform plan -var-file=../config/poc/test/terraform.tfvars -out=example.tfplan
terraform apply -input=false -auto-approve example.tfplan
```

Run random password example:
```
cd terraform/randompass
terraform init -var-file=../config/poc/test/terraform.tfvars
terraform plan -var-file=../config/poc/test/terraform.tfvars -out=example.tfplan
terraform apply -input=false -auto-approve example.tfplan
```
As a result it is expected that in the specified KV there is a secret `dbpassword` with the password used in a test bellow.


Create a key in the keyvault:
```
az keyvault key create --vault-name ${KV_NAME} \
  --name sops --protection software
```

Set access policy:
```
az ad user list --display-name "User Name" | jq -r ".[].id"
az keyvault set-policy --name  ${KV_NAME} \
  --object-id $(z ad user list --display-name "David Liderman" | jq -r ".[].id") \
  --key-permissions Get List Encrypt Decrypt
```
Get key ID:
```
export KEY_ID=$(az keyvault key show -n sops \
    --vault-name ${KV_NAME} \
    --query key.kid -o tsv)
```

Run encryption example:
```
cd terraform/encrypt
sops --encrypt --azure-kv ${KEY_ID} dbcredentials.json > db-secret.enc.json
terraform init -var-file=../config/poc/test/terraform.tfvars
terraform plan -var-file=../config/poc/test/terraform.tfvars -out=example.tfplan
terraform apply -input=false -auto-approve example.tfplan
```

## Test

Add client IP to firewall rule:
```
az mariadb server firewall-rule create --resource-group RG-EUR-WW-POC-DL \
  --server db-eur-ww-poc-dl --name AllowMyIP \
  --start-ip-address $(curl -s https://ifconfig.me/ip) \
  --end-ip-address $(curl -s https://ifconfig.me/ip)
```
Get password from a KV:
```
az keyvault secret show -n dbpassword \
   --vault-name ${KV_NAME} --query value -o tsv
```
Connect:
```
mysql -h db-eur-ww-poc-dl.mariadb.database.azure.com \
  -u dbadmin@db-eur-ww-poc-dl -p
```
At prompt type `status` to view DB status.

Cleanup:
```
az mariadb server delete --resource-group RG-EUR-WW-POC-DL \
  --name db-eur-ww-poc-dl
```