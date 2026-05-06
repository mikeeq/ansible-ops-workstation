FROM fedora:44

# ENV container docker
ENV FEDORA_USERNAME=mikee

RUN dnf clean all \
    && dnf update -y \
    && dnf upgrade -y \
    && dnf install -y \
      python3-pip \
      systemd \
      curl \
      git \
      ShellCheck \
      python3-argcomplete \
      python3-psutil \
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

# Install mise
RUN curl https://mise.run | sh \
    && ln -s /root/.local/bin/mise /usr/local/bin/mise

# Install tools via mise
COPY mise.toml /root/.config/mise/config.toml
RUN mise install && mise reshim
ENV PATH="/root/.local/share/mise/shims:${PATH}"

RUN useradd ${FEDORA_USERNAME} && usermod -aG wheel ${FEDORA_USERNAME}

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
