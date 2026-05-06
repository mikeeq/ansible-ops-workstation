FROM fedora:44

# ENV container docker
ENV FEDORA_USERNAME=mikee

RUN dnf clean all \
    && dnf update -y \
    && dnf upgrade -y \
    && dnf install -y \
      systemd \
      curl \
      git \
      sudo \
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

RUN useradd -m ${FEDORA_USERNAME} && usermod -aG wheel ${FEDORA_USERNAME} \
    && echo "${FEDORA_USERNAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Fix PAM error in container - https://github.com/geerlingguy/docker-fedora41-ansible/issues/2
RUN chmod 400 /etc/shadow

# Install mise as user
USER ${FEDORA_USERNAME}
ENV MISE_YES=1
RUN curl https://mise.run | sh


# Install tools via mise
COPY --chown=${FEDORA_USERNAME} mise.toml /home/${FEDORA_USERNAME}/.config/mise/config.toml
RUN ~/.local/bin/mise install && ~/.local/bin/mise reshim
ENV PATH="/home/${FEDORA_USERNAME}/.local/share/mise/shims:/home/${FEDORA_USERNAME}/.local/bin:${PATH}"

USER root

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
