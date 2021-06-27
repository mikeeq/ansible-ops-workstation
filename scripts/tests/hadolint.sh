#!/usr/bin/env bash

DOCKERFILE_PATH=${1:-Dockerfile}

echo "Linting Dockerfile - hadolint..."
docker run \
	--rm \
	-t \
	-v "${REPO_PATH}"/../:/repo \
	"${RUNNER_DOCKER_IMAGE}" /bin/bash -c " \
		cd /repo/${REPO_DIR_NAME}; \
		hadolint ${DOCKERFILE_PATH} \
	"
