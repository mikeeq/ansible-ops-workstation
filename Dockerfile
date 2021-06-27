FROM fedora:32

ENV container docker

# https://github.com/wagoodman/dive/releases
ARG DIVE_VERSION=0.9.2
# https://github.com/hadolint/hadolint/releases
ARG HADOLINT_VERSION=1.17.5

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*; \
rm -f /etc/systemd/system/*.wants/*; \
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*; \
rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN dnf clean all && \
    dnf update -y && \
    dnf upgrade -y && \
    dnf install -y python3-pip && \
    dnf clean all

# https://pypi.org/project/pip/
RUN pip3 install --upgrade pip==20.0.2 && \
    pip3 install \
      ansible==2.9.5 \
      ansible-lint==4.2.0 \
      yamllint==1.20.0 \
      packaging==20.0 \
      pyOpenSSL==19.1.0

# Dive
RUN curl -LO https://github.com/wagoodman/dive/releases/download/v${DIVE_VERSION}/dive_${DIVE_VERSION}_linux_amd64.tar.gz && \
    tar -xf dive_${DIVE_VERSION}_linux_amd64.tar.gz && \
    mv ./dive /usr/local/bin/dive && \
    rm -rf dive_${DIVE_VERSION}_linux_amd64.tar.gz

# Hadolint
RUN curl -L "https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-x86_64" -o hadolint && \
    chmod +x ./hadolint && mv ./hadolint /usr/local/bin/hadolint

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
