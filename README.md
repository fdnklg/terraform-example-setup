# terraform-example-setup

Terraform is a helpful tool to organize the process of setting up an EC2 instance on AWS. Setup EC2 Instances without hasseling through the complex UI of AWS. 

FYI: Keep in mind that services like AWS can come with costs depending on your setup.

## terraform.tfvars
To start the process create a ```terraform.tfvars``` file in the root directory. Inside you add the credentials regarding your aws account.

```
# Mandatory fields:

profile = "your aws profile name"
security_group = "sg-XXXXXXXX" # the security group of your profile
key_name = "name of the aws keypair name"
subnet_id = "subnet-XXXXXXXX"
vpc_id = "vpc-XXXXXXXX"
```

You can find all necessary information inside your Amazon account.

If you haven't already install terraform via brew on your machine.

```
brew install terraform
```

Edit the ```main.tf``` to your preferenced setup such as: security group, instance name, key location, ssh connection and others (check the commented section).


Start the init process inside the working directory

```
terraform init
```

To initialize the instance just type:

```
terraform apply
```

If you want to remove your instance completely just type

```
terraform destroy
```

Just type ```terraform``` in your console to find a description of all available commands.