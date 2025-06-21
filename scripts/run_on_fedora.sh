#!/bin/bash

sudo dnf install -y git python ansible libselinux-python ;
sudo systemctl disable firewalld ;
sudo setenforce 0 ;

ansible-playbook -i inventory/hosts fedora.yaml -K
