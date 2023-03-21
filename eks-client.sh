#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

mkdir -p /home/ec2-user/eks-client-install
cd /home/ec2-user/eks-client-install

LOG=eks-client-install.log
USER_ID=$(id -u)
if [ $USER_ID -ne 0 ]; then
	echo  -e "$R You are not the root user, you dont have permissions to run this $N"
	exit 1
fi

VALIDATE(){
	if [ $1 -ne 0 ]; then
		echo -e "$2 ... $R FAILED $N"
		exit 1
	else
		echo -e "$2 ... $G SUCCESS $N"
	fi

}

curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" &>> $LOG

VALIDATE $? "Downloaded AWS CLI V2"
AWS_FOLDER="aws"
if [ -d "$AWS_FOLDER" ]; then
    echo -e "AWS directory already exists...$Y SKIPPING Unzip $N"
else
    unzip awscliv2.zip &>> $LOG
    VALIDATE "unzip AWS CLI V2"
fi

./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update &>> $LOG

VALIDATE $? "Updated AWS CLI V2"

curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
VALIDATE $? "Downloaded eksctl command"
chmod +x /tmp/eksctl
VALIDATE $?  "Added execute permissions to eksctl"
mv /tmp/eksctl /usr/local/bin
VALIDATE $? "moved eksctl to bin folder"

curl -s -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.24.10/2023-01-30/bin/linux/amd64/kubectl
VALIDATE $? "Downloaded kubectl 1.24 version"
chmod +x kubectl
VALIDATE $?  "Added execute permissions to kubectl"
mv kubectl /usr/local/bin/kubectl
VALIDATE $?  "moved kubectl to bin folder"