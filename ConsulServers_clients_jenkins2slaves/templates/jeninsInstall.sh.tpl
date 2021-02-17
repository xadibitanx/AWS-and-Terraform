#!/bin/bash
set -xe
sudo apt update
sudo apt install openjdk-8-jdk -y 
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update -y
sudo apt install jenkins -y
sudo ufw allow 8080
curl -L https://raw.githubusercontent.com/hgomez/devops-incubator/master/forge-tricks/batch-install-jenkins-plugins.sh -o batch-install-jenkins-plugins.sh
systemctl restart jenkins
sleep 145
sed -i 's?<useSecurity>true</useSecurity>?<useSecurity>false</useSecurity>?' /var/lib/jenkins/config.xml
systemctl restart jenkins

