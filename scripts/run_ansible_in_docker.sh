#!/usr/bin/env bash

DOCKER_IMAGE=${DOCKER_IMAGE-fedora_systemd}

docker run \
  --name ${DOCKER_IMAGE} \
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
  ${DOCKER_IMAGE} /bin/bash -c " \
    ansible-playbook -e docker_tests_flag=true -e ansible_python_interpreter=/usr/bin/python3 -i inventory/hosts.yml fedora.yml"

docker exec \
  -t \
  ${DOCKER_IMAGE} /bin/bash -c " \
    ansible-playbook -e docker_tests_flag=true -e ansible_python_interpreter=/usr/bin/python3 -i inventory/hosts.yml fedora.yml"

livecd_exitcode=$?

docker stop ${DOCKER_IMAGE}

exit $livecd_exitcode
