FROM openjdk:14.0.1-slim


ENV USER spinnaker
ENV PORT 8084
ENV CONFIG_PATH /usr/lib/spinnaker-gate/config/gate-local.yml

# Add Spinnaker User / Group
RUN useradd -c 'Spinnaker User' -d /home/spinnaker -u 1200 -U -ms /bin/bash spinnaker
RUN chown -R spinnaker /home/spinnaker

ADD src/gate-web/build/distributions/gate.tar /usr/lib
RUN mv /usr/lib/gate /usr/lib/spinnaker-gate && \
    chown -R ${USER}:${USER} /usr/lib/spinnaker-gate

RUN ln -s /usr/lib/spinnaker-gate/bin/gate /usr/bin/spinnaker-gate


COPY Dockerfile /etc/Dockerfile
COPY entrypoint.sh /sbin/entrypoint
RUN chown -R ${USER}:${USER} /sbin/entrypoint && \
    chmod +x /sbin/entrypoint
HEALTHCHECK CMD curl http://localhost:${PORT}/health | grep UP || exit 1
USER ${USER}
EXPOSE ${PORT}/tcp
ENTRYPOINT ["/sbin/entrypoint"]