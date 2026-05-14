#!/bin/bash

mise install

ansible-playbook -i inventory/hosts fedora.yaml -K
