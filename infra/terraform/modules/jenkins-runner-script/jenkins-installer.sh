#!/bin/bash
sudo apt update
sudo apt -y upgrade
sudo apt update
sudo apt -y install docker.io docker-compose
usermod -aG docker ubuntu

cat > /home/ubuntu/docker-compose.yaml << EOF
version: '2'
services:
  jenkins:
    image: jenkins/jenkins:lts
    privileged: true
    user: root
    ports:
      - 8080:8080
      - 50000:50000
    container_name: jenkins
    volumes:
      - ./jenkins_compose/jenkins_configuration:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock

EOF

#! START_JENKINS !#
docker-compose -f /home/ubuntu/docker-compose.yaml up -d