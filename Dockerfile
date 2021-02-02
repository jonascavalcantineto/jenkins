FROM jenkins/jenkins:lts
USER root
RUN jenkins-plugin-cli --plugins docker-slaves github-branch-source:1.8
RUN apt-get update
RUN apt-get install -y  \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    gnupg2

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

RUN apt-get update
RUN apt-get install -y \
        docker-ce=5:19.03.14~3-0~debian-stretch \
        docker-ce-cli=5:19.03.14~3-0~debian-stretch \
        containerd.io \
         python3 \
         python3-pip

#Kubectl
RUN set -ex \
        && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
        && echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list

RUN apt-get update
RUN apt-get install -y kubectl

RUN mkdir -p /root/.kube
ADD confs/config /root/.kube/config

#aws-iam-authenticator
RUN set -ex \
        && curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.18.9/2020-11-02/bin/linux/amd64/aws-iam-authenticator \
        && chmod +x ./aws-iam-authenticator \
        && mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$PATH:$HOME/bin \
        && echo 'export PATH=$PATH:$HOME/bin' >> ~/.bash_profile

#eksctl
RUN set -ex \
        && curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp \
        && mv /tmp/eksctl /usr/local/bin

COPY confs/aws /root/.aws

#awscli
RUN pip3 install awscli --upgrade
RUN aws eks update-kubeconfig --name eks-gjbl-01

EXPOSE 8080 50000