#!/usr/bin/env bash

YAMLLINT_PATH="${1:-.}"

echo "Linting yaml files - yamllint..."
docker run \
	--rm \
	-t \
	-v "${REPO_PATH}"/../:/repo \
	"${RUNNER_DOCKER_IMAGE}" /bin/bash -c " \
		cd /repo/${REPO_DIR_NAME}; \
		yamllint -s ${YAMLLINT_PATH} \
	"
