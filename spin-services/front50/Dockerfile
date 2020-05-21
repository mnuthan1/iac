FROM centos:centos8.1.1911


ENV USER spinnaker
ENV PORT 8080
ENV CONFIG_PATH /usr/lib/spinnaker-front50/config/front50-local.yml
ENV REDIS_ENABLED true

# Add Spinnaker User / Group
RUN useradd -c 'Spinnaker User' -d /home/spinnaker -u 1200 -U -ms /bin/bash spinnaker
RUN chown -R spinnaker /home/spinnaker

RUN yum update -y && \
    yum install -y wget curl && \
    curl -O https://download.java.net/java/GA/jdk14.0.1/664493ef4a6946b186ff29eb326336a2/7/GPL/openjdk-14.0.1_linux-x64_bin.tar.gz && \
    tar xvf openjdk-14.0.1_linux-x64_bin.tar.gz && \
    ls -lrt && \
    mv jdk-14.0.1 /opt/ && \
    rm -f openjdk-14.0.1_linux-x64_bin.tar.gz

ENV JAVA_HOME="/opt/jdk-14.0.1"
ENV PATH="${JAVA_HOME}/bin:${PATH}"

ADD src/front50-web/build/distributions/front50.tar /usr/lib
RUN mv /usr/lib/front50 /usr/lib/spinnaker-front50 && \
    chown -R ${USER}:${USER} /usr/lib/spinnaker-front50
RUN ln -s /usr/lib/spinnaker-front50/bin/front50 /usr/bin/spinnaker-front50

RUN mkdir -p /opt/front50/plugins && chown -R ${USER}:${USER} /opt/front50/plugins

COPY Dockerfile /etc/Dockerfile
COPY entrypoint.sh /sbin/entrypoint
RUN chown -R ${USER}:${USER} /sbin/entrypoint && \
    chmod +x /sbin/entrypoint

HEALTHCHECK CMD curl http://localhost:${PORT}/health | grep UP || exit 1
USER ${USER}
EXPOSE ${PORT}/tcp
ENTRYPOINT ["tail", "-f", "/dev/null"]