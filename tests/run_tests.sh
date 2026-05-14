#!/bin/bash

ANSIBLE_CONFIG='' ansible-galaxy collection install -r requirements.yaml --force
ANSIBLE_CONFIG='' ansible-playbook playbook.yaml
