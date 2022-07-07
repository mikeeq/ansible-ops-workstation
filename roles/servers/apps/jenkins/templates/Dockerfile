FROM jenkins/jenkins:slim-jdk11

USER root

RUN apt-get update \
    && apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y \
        docker-ce-cli \
        python3-pip \
    && pip3 install --no-cache \
        # https://pypi.org/project/jenkins-job-builder/
        jenkins-job-builder==3.12.0

ARG DOCKER_GID=955

RUN groupadd -g ${DOCKER_GID} docker \
    && usermod -a -G docker jenkins

USER jenkins

# https://www.jenkins.io/projects/blueocean/
# https://github.com/jenkinsci/blueocean-plugin/releases
# https://plugins.jenkins.io/blueocean/#releases
# https://plugins.jenkins.io/workflow-aggregator/#releases

RUN jenkins-plugin-cli --plugins "blueocean:1.25.2 workflow-aggregator:2.6 rebuild:1.33 ansicolor:1.0.1 git:4.10.3 linenumbers:1.3"

# ❯ docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
