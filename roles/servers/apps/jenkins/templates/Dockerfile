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
        git-crypt \
        git \
        libyaml-dev \
        sshpass \
        passlib \
    && pip3 install --no-cache-dir \
        # https://pypi.org/project/jenkins-job-builder/
        # jenkins-job-builder \
        # https://pypi.org/project/ansible/
        ansible \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ARG DOCKER_GID=955

RUN groupadd -g ${DOCKER_GID} docker \
    && usermod -a -G docker jenkins

WORKDIR /opt/jjb

USER jenkins

# https://www.jenkins.io/projects/blueocean/
# https://github.com/jenkinsci/blueocean-plugin/releases

# https://plugins.jenkins.io/blueocean/#releases
# https://plugins.jenkins.io/workflow-aggregator/#releases
# https://plugins.jenkins.io/rebuild/#releases
# https://plugins.jenkins.io/ansicolor/#releases
# https://plugins.jenkins.io/git/#releases
# https://plugins.jenkins.io/linenumbers/#releases
# https://plugins.jenkins.io/multiple-scms/
# https://plugins.jenkins.io/pipeline-as-yaml/
# https://plugins.jenkins.io/ws-cleanup/
# https://plugins.jenkins.io/configuration-as-code/

# RUN jenkins-plugin-cli --plugins "workflow-aggregator:590.v6a_d052e5a_a_b_5 rebuild:1.34 ansicolor:1.0.2 git:4.14.3 linenumbers:1.3 multiple-scms:0.8 pipeline-as-yaml:0.16-rc ws-cleanup:0.44"

# linenumbers plugin fails to print json output in ansible, it's merging multiple lines as one
RUN jenkins-plugin-cli --plugins "blueocean workflow-aggregator rebuild ansicolor git multiple-scms pipeline-as-yaml ws-cleanup locale pipeline-multibranch-defaults basic-branch-build-strategies pipeline-stage-view configuration-as-code job-dsl dark-theme git-parameter"

# ❯ docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword

USER root

RUN git clone --single-branch --branch feature/pipeline_as_yaml https://github.com/mikeeq/jenkins-job-builder \
    && cd jenkins-job-builder \
    && pip3 install -r requirements.txt \
    && PBR_VERSION=9.9.9 python3 setup.py install

USER jenkins
