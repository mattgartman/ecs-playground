#terraform resources to create
#ec2 instance
#iam role for jenkins
#efs file system
# - give apprriate security group acces
#security group for Ec2 isntance
#elb for jenkins

#java
sudo yum install -y java-1.7.0-openjdk

#tcpdump for diag
sudo yum install -y tcpdump

#install jenkins
sudo yum install -y wget
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install -y jenkins


#install pip
sudo rpm -iUvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum -y update #maybe not needed here but still good to do; takes a long time
sudo yum -y install python-pip

#install aws cli
sudo pip install awscli
sudo ln -s /usr/bin/aws /usr/local/bin/aws #match aws linux AMI location

#install jq
sudo yum -y install jq

#install git
sudo yum -y install git

#mount efs
EC2_AVAIL_ZONE=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
EC2_REGION="`echo \"$EC2_AVAIL_ZONE\" | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'`"
EFS_FILE_SYSTEM_NAME='Jenkins'
EFS_FILE_SYSTEM_ID=`/usr/local/bin/aws efs describe-file-systems --region $EC2_REGION | jq '.FileSystems[]' | jq 'select(.Name=="'$EFS_FILE_SYSTEM_NAME'")' | jq -r '.FileSystemId'`
NIC_MAC=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/)
SUBNET_ID=$(curl -s "http://169.254.169.254/latest/meta-data/network/interfaces/macs/"$NIC_MAC"subnet-id")
aws efs describe-mount-targets --region $EC2_REGION --file-system $EFS_FILE_SYSTEM_ID --query 'MountTargets[?SubnetId==`'$SUBNET_ID'`]'
aws efs describe-mount-targets --region $EC2_REGION --file-system $EFS_FILE_SYSTEM_ID --query 'MountTargets[?SubnetId==`'$SUBNET_ID'`]'|jq ".[].IpAddress" -r
DIR_SRC=$(aws efs describe-mount-targets --region $EC2_REGION --file-system $EFS_FILE_SYSTEM_ID --query 'MountTargets[?SubnetId==`'$SUBNET_ID'`]'|jq ".[].IpAddress" -r)
DIR_TGT=/mnt/efs 
#Create mount point
sudo mkdir $DIR_TGT
#Backup fstab
sudo cp -p /etc/fstab /etc/fstab.back-$(date +%F)
#Append line to fstab
echo -e "$DIR_SRC:/ \t\t $DIR_TGT \t\t nfs4 \t\t defaults \t\t 0 \t\t 0" | sudo tee -a /etc/fstab
#Mount EFS file system
mount -a

#create jenkins home
sudo mkdir /mnt/efs/jenkins
sudo rm -rf /var/lib/jenkins
sudo ln -s /mnt/efs/jenkins /var/lib/jenkins
sudo chown jenkins:jenkins /mnt/efs/jenkins/



#install docker
sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
sudo yum -y install docker-engine
#enable tcp access to docker for jenkins plugin
sudo sed -i 's/dockerd/dockerd -H unix:\/\/\/var\/run\/docker.sock -H tcp:\/\/127.0.0.1:4243/g' /usr/lib/systemd/system/docker.service
sudo systemctl enable docker.service
sudo systemctl start docker

#add jenkins to docker group
sudo usermod -a -G docker jenkins 
#start jenkins
sudo service jenkins start
sudo chkconfig jenkins on

#make centos user part of docker
sudo usermod -a -G docker centos