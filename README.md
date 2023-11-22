# Introduction
This project shows how to use secrets in terraform.

Three examples are provided:
* use of environment variables initialized from a key vault
* use of random secret values stored for future use in a key vault
* encryption of secret values using Mozilla SOPS

# Getting Started
See `terraform/config/{project}/{environment}/README.md` for instructions ho to use examples.

All eximples assume that a resource group configured in `terraform/config/{project}/{environment}/terraform.tfvars` exists and the user running examples has a `Contributor` role in it.

For SOPS example it is required that `sops` is installed on the environment running the example. See [Confluence article](https://adeccogroup.atlassian.net/wiki/spaces/CIE/pages/14981169175/How+to+encrypt+secrets+SOPS) for instructions how to install SOPS.

For demonstration purposes the `dbcredentials.json` file with credentials in clear text is in the repository. In real scenarios it is not supposed to be pushed, only the encrypted file `db-secret.enc.json` is pushed to the repository.

Examples create an instance of MariaDB with passwords provided in different ways. The README.md lists instructions how the DB can be tested and removed for clean up.