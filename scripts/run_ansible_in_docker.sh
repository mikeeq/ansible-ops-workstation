#!/usr/bin/env bash

docker run \
  --name fedora_systemd \
  -d \
  -t \
  --privileged \
  -v $(pwd):/repo \
  -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
  -w /repo \
  --rm \
  fedora-systemd:latest

docker exec \
  -t \
  fedora_systemd /bin/bash -c " \
    ansible-playbook -e docker_tests_flag=true -e ansible_python_interpreter=/usr/bin/python3 -i inventory/hosts.yml fedora.yml"

docker exec \
  -t \
  fedora_systemd /bin/bash -c " \
    ansible-playbook -e docker_tests_flag=true -e ansible_python_interpreter=/usr/bin/python3 -i inventory/hosts.yml fedora.yml"

livecd_exitcode=$?

docker stop fedora_systemd

exit $livecd_exitcode
