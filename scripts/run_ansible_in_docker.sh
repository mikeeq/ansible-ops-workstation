#!/usr/bin/env bash

DOCKER_IMAGE=${DOCKER_IMAGE:-fedora_systemd}
ANSIBLE_PLAYBOOK=${ANSIBLE_PLAYBOOK:-fedora.yaml}
docker run \
  --name ${DOCKER_IMAGE} \
  -d \
  -t \
  --privileged \
  -v "$(pwd)":/repo \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
  --cgroupns host \
  -w /repo/playbooks \
  --rm \
  ${DOCKER_IMAGE}

CONTAINER_USER=${CONTAINER_USER:-mikee}

docker exec \
  -t \
  -u ${CONTAINER_USER} \
  ${DOCKER_IMAGE} /bin/bash -c " \
    ansible-galaxy collection install -r ../requirements.yaml -p ~/.ansible/collections"

docker exec \
  -t \
  -u ${CONTAINER_USER} \
  ${DOCKER_IMAGE} /bin/bash -c " \
    ansible-playbook -e ansible_run_in_docker=true --skip-tags dont_run_in_docker -i ../inventory/hosts.yaml ${ANSIBLE_PLAYBOOK}"

docker exec \
  -t \
  -u ${CONTAINER_USER} \
  ${DOCKER_IMAGE} /bin/bash -c " \
    ansible-playbook -e ansible_run_in_docker=true --skip-tags dont_run_in_docker -i ../inventory/hosts.yaml ${ANSIBLE_PLAYBOOK}"

ansible_exitcode=$?

docker stop ${DOCKER_IMAGE}

exit $ansible_exitcode
