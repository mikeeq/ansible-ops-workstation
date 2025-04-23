#!/usr/bin/env bash

DOCKER_IMAGE=${DOCKER_IMAGE:-fedora_systemd}
ANSIBLE_PLAYBOOK=${ANSIBLE_PLAYBOOK:-fedora.yml}
docker run \
  --name ${DOCKER_IMAGE} \
  -d \
  -t \
  --privileged \
  -v $(pwd):/repo \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
  --cgroupns host \
  -w /repo/playbooks \
  --rm \
  ${DOCKER_IMAGE}

docker exec \
  -t \
  ${DOCKER_IMAGE} /bin/bash -c " \
    ansible-playbook -e ansible_run_in_docker=true --skip-tags dont_run_in_docker -i ../inventory/hosts.yml ${ANSIBLE_PLAYBOOK}"

docker exec \
  -t \
  ${DOCKER_IMAGE} /bin/bash -c " \
    ansible-playbook -e ansible_run_in_docker=true --skip-tags dont_run_in_docker -i ../inventory/hosts.yml ${ANSIBLE_PLAYBOOK}"

ansible_exitcode=$?

docker stop ${DOCKER_IMAGE}

exit $ansible_exitcode
