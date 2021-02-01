FROM jenkins/jenkins:lts
RUN jenkins-plugin-cli --plugins docker-slaves github-branch-source:1.8
USER root
RUN apt-get update
RUN apt-get install -y  \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
RUN apt-get update
RUN apt-get install -y \
        docker-ce=5:19.03.14~3-0~ubuntu-focal \
        docker-ce-cli=5:19.03.14~3-0~ubuntu-focal \
        containerd.io
EXPOSE 8080 50000