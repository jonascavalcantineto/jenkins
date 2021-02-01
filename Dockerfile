FROM jenkins/jenkins:lts
RUN jenkins-plugin-cli --plugins docker-slaves github-branch-source:1.8