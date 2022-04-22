FROM fedora:35

# ENV container docker
ENV FEDORA_USERNAME=mikee

# https://github.com/wagoodman/dive/releases
ARG DIVE_VERSION=0.10.0
# https://github.com/hadolint/hadolint/releases
ARG HADOLINT_VERSION=2.7.0

ADD https://github.com/AkihiroSuda/clone3-workaround/releases/download/v1.0.0/clone3-workaround.x86_64 /clone3-workaround
RUN chmod 755 /clone3-workaround
SHELL ["/clone3-workaround", "/bin/sh", "-c"]

RUN dnf clean all \
    && dnf update -y \
    && dnf upgrade -y \
    && dnf install -y \
      python3-pip \
      systemd \
      ShellCheck \
    && dnf clean all

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*; \
rm -f /etc/systemd/system/*.wants/*; \
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*; \
rm -f /lib/systemd/system/anaconda.target.wants/*;

# https://pypi.org/project/pip/
RUN pip3 install --no-cache-dir --upgrade pip==22.0.4 && \
    pip3 install --no-cache-dir \
      # https://pypi.org/project/ansible/
      ansible==5.5.0 \
      # https://pypi.org/project/ansible-lint/
      ansible-lint==6.0.2 \
      # https://pypi.org/project/yamllint/
      yamllint==1.26.3 \
      # https://pypi.org/project/packaging/
      packaging==21.3 \
      # https://pypi.org/project/pyOpenSSL/
      pyOpenSSL==22.0.0

# Dive
RUN curl -LO https://github.com/wagoodman/dive/releases/download/v${DIVE_VERSION}/dive_${DIVE_VERSION}_linux_amd64.tar.gz && \
    tar -xf dive_${DIVE_VERSION}_linux_amd64.tar.gz && \
    mv ./dive /usr/local/bin/dive && \
    rm -rf dive_${DIVE_VERSION}_linux_amd64.tar.gz

# Hadolint
RUN curl -L "https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-x86_64" \
      -o /usr/local/bin/hadolint \
    && chmod +x /usr/local/bin/hadolint

RUN useradd ${FEDORA_USERNAME} && usermod -aG wheel ${FEDORA_USERNAME}

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
