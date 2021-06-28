#!/usr/bin/env bash

echo "Scanning image: ${DOCKER_IMAGE_LOCAL} ..."
docker run \
	--rm \
	-t \
	-v /var/run/docker.sock:/var/run/docker.sock \
	"${RUNNER_DOCKER_IMAGE}" /bin/bash -c " \
		CI=true dive ${DOCKER_IMAGE_LOCAL} \
	"
