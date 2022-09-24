FROM alpine
ENV GITEA_CUSTOM /data/gitea

COPY --from=gitea/gitea:latest /usr/local/bin/gitea /usr/local/bin/gitea

RUN apk --update --no-cache add git python3 py-pip bash && \
    pip install git+https://github.com/bloomreach/s4cmd.git && \
    rm -rf /var/cache/apk/*

ADD entrypoint.sh /
ADD backup.sh /
ADD crontab /etc/crontab

ENTRYPOINT ["/entrypoint.sh"]
