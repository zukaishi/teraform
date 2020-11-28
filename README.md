# teraform
brew install tfenv
<br><br>
tfenv list-remote
<br><br>
0.14.0-rc1<br>
0.14.0-beta2<br>
0.14.0-beta1<br>
0.14.0-alpha20201007<br>
0.14.0-alpha20200923<br>
0.14.0-alpha20200910<br>
0.13.5<br>
0.13.4<br>
0.13.3<br>
<br><br>
tfenv install 0.13.5
<br>
tfenv use 0.13.5<br>
Switching default version to v0.13.5<br>
Switching completed<br>
<br><br>
terraform version<br>
Terraform v0.13.5<br>
<br><br>
terraform -install-autocomplete
<br><br>
aws configure --profile YOUR_PROFILE_NAME
<br>
AWS Access Key ID[None]: 
<br>
AWS Secret Access Key[None]: 
<br>
Default region name[None]: ap-northeast-1
<br>
Default output format[None]: json
<br>
mkdir s3
<br>
touch main.tf providers.tf variables.tf
<br>
terraform init
<br>
Terraform has been successfully initialized!
<br>
