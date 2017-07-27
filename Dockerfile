FROM node:4-alpine
MAINTAINER adolphlwq kenan3015@gmail.com

ENV GHOST_ZIP_URL=https://github.com/TryGhost/Ghost/releases/download/1.0.0/Ghost-1.0.0.zip \
    GHOST_ZIP_NAME=Ghost-1.0.0.zip \
    USER=ghost
WORKDIR /var/www/ghost

ADD config.development.json /var/www/ghost/config.development.json
ADD start.sh /var/www/ghost/start.sh

RUN apk add --update --no-cache ca-certificates curl unzip && \
    rm -rf /var/cache/apk/ && \
    adduser -D -u 9001 ghost


# download ghost zip and extract
RUN curl -Lo $GHOST_ZIP_NAME $GHOST_ZIP_URL && \
    unzip $GHOST_ZIP_NAME && \
    rm $GHOST_ZIP_NAME && \
    npm install && \
    npm install -g knex-migrator && \
    apk del curl unzip && \
    chown ghost:ghost -R /var/www/ghost && \
    chmod 755 -R /var/www/ghost && \
    chmod +x start.sh

USER $USER
CMD ["./start.sh"]
