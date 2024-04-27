# https://hub.docker.com/r/jenkins/jenkins/tags
FROM jenkins/jenkins:slim-jdk21

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
    && rm /usr/lib/python3.11/EXTERNALLY-MANAGED \
    && pip3 install --no-cache-dir \
        # https://pypi.org/project/jenkins-job-builder/
        # jenkins-job-builder \
        # https://pypi.org/project/ansible/
        ansible \
        # https://pypi.org/project/passlib/
        passlib \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ARG DOCKER_GID=955

RUN groupadd -g ${DOCKER_GID} docker \
    && usermod -a -G docker jenkins

WORKDIR /opt/

RUN git clone --single-branch --branch feature/pipeline_as_yaml https://github.com/mikeeq/jenkins-job-builder \
    && cd jenkins-job-builder \
    && pip3 install -r requirements.txt \
    && PBR_VERSION=9.9.9 python3 setup.py install

# # https://github.com/jenkinsci/pipeline-as-yaml-plugin/pull/77
# ARG MAVEN_VERSION=3.9.6
# # ARG USER_HOME_DIR="/root"
# ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

# RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
#  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
#  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
#  && rm -f /tmp/apache-maven.tar.gz \
#  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

# # ENV MAVEN_HOME /usr/share/maven
# # ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

# RUN git clone --single-branch --branch feature/refresh-december-2023 https://github.com/jonesbusy/pipeline-as-yaml-plugin \
#     && cd pipeline-as-yaml-plugin \
#     && mvn package

# mvn install
# mvn package -Dmaven.test.skip
# mvn package -DskipTests

# /usr/share/jenkins/ref/plugins/

# /opt/pipeline-as-yaml-plugin/target
# -rw-r--r--  1 root root   6064 Jan  2 16:14 pipeline-as-yaml-0.17-rc-SNAPSHOT.pom
# -rw-r--r--  1 root root 197163 Jan  2 16:24 pipeline-as-yaml.hpi
# -rw-r--r--  1 root root 100400 Jan  2 16:24 pipeline-as-yaml.jar


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
# cloudbees-folder
# timestamper
# build-timeout
RUN jenkins-plugin-cli --plugins "blueocean workflow-aggregator rebuild ansicolor git multiple-scms pipeline-as-yaml ws-cleanup locale pipeline-multibranch-defaults basic-branch-build-strategies pipeline-stage-view configuration-as-code job-dsl dark-theme git-parameter conditional-buildstep run-condition theme-manager"

# ❯ docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
