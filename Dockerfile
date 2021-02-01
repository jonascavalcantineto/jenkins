FROM jenkins/jenkins:lts
RUN jenkins-plugin-cli --plugins docker-slaves github-branch-source:1.8
EXPOSE 8080 50000