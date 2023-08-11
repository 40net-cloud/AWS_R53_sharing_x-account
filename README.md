# Demo cross account R53 resolver sharing
## Deploy
```
git clone https://github.com/xxradar/AWS_R53_sharing_x-account.git
```
```
cd ./tf
```
```
cp terraform.tfvars.example terraform.tfvars
```
Update terraform.tfvars with access_key and secret_key
```
terraform init
```
```
terraform apply
```
## Prerequisite
```
rm -rf ./key.pem
terraform output -raw private_key >key.pem
chmod 400 ./key.pem
```

## DNS testing
```
ssh -i ./key.pem ubuntu@<jumpbox>
```
```
dig www.radarhack.com
...
dig demo.radarhacker.com  #DNS forward to DigitalOceans hosted zone
...
dig testing.radarhacker.com  #DNS forward to DigitalOceans hosted zone
...
dig my-instance.demo-radarhack.internal #r53 internal zone
```

## Check invite on shared account
Invite should be send to other account.

## DNS testing on shared account
The other account can access
```
dig www.radarhack.com
...
dig demo.radarhacker.com  #DNS forward
...
dig testing.radarhacker.com  #DNS forward
...
dig my-instance.demo-radarhack.internal # not configured r53 internal zone ... adding a rule to inbound endpoints will solve
```
## TODO
- rename subnets ...
- add var for account_id
- tf for automation of shared account
