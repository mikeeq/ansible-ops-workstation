# https://hub.docker.com/r/jenkins/jenkins/tags
FROM jenkins/jenkins:slim-jdk11

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gnupg \
        lsb-release \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        docker-ce-cli \
        python3-pip \
    && pip3 install --no-cache-dir \
        # https://pypi.org/project/jenkins-job-builder/
        jenkins-job-builder==4.1.0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ARG DOCKER_GID=955

RUN groupadd -g ${DOCKER_GID} docker \
    && usermod -a -G docker jenkins

USER jenkins

# https://www.jenkins.io/projects/blueocean/
# https://github.com/jenkinsci/blueocean-plugin/releases

# https://plugins.jenkins.io/blueocean/#releases
# https://plugins.jenkins.io/workflow-aggregator/#releases
# https://plugins.jenkins.io/rebuild/#releases
# https://plugins.jenkins.io/ansicolor/#releases
# https://plugins.jenkins.io/git/#releases
# https://plugins.jenkins.io/linenumbers/#releases

# blueocean:1.25.5
RUN jenkins-plugin-cli --plugins "workflow-aggregator:590.v6a_d052e5a_a_b_5 rebuild:1.34 ansicolor:1.0.1 git:4.11.3 linenumbers:1.3"

# ❯ docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword