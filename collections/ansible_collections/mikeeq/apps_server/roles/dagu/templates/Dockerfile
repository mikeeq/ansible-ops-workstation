# {{ ansible_managed }}
# https://github.com/dagucloud/dagu/blob/main/Dockerfile
FROM {{ dagu_base_image }}

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        git-crypt \
        python3 \
        python3-xmltodict \
        sshpass \
        xz-utils \
        zstd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# mise for every user, its tools are installed per user into ~/.local/share/mise
RUN curl -fsSL https://mise.run \
    | MISE_INSTALL_PATH=/usr/local/bin/mise {% if dagu_mise_version %}MISE_VERSION=v{{ dagu_mise_version | regex_replace('^v', '') }} {% endif %}sh \
    && mise --version

ENV MISE_YES=1
