#!/usr/bin/env bash

SHELLCHECK_PATH=${1:-$(find . -type f -name "*.sh" |  tr '\n' ' ')}

echo "Linting bash scripts - shellcheck..."
docker run \
	--rm \
	-t \
	-v "${REPO_PATH}"/../:/repo \
	"${RUNNER_DOCKER_IMAGE}" /bin/bash -c " \
		cd /repo/${REPO_DIR_NAME}; \
		shellcheck -e $SHELLCHECK_EXCLUDE_CODES ${SHELLCHECK_PATH} \
	"
