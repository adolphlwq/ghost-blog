FROM node:8.14-alpine
MAINTAINER adolphlwq kenan3015@gmail.com

ENV GHOST_VERSION=2.7.1 \
    GHOST_CLI_VERSION=1.8.1 \
    GHOST_INSTALL=/var/www/ghost
    
WORKDIR ${GHOST_INSTALL}

RUN apk add --update --no-cache ca-certificates bash 'su-exec>=0.2'&& \
    rm -rf /var/cache/apk/ && \
    npm install -g "ghost-cli@${GHOST_CLI_VERSION}" && \
    npm install -g knex-migrator

RUN set -ex;\
    chown node:node -R ${GHOST_INSTALL};\
    chmod 755 -R ${GHOST_INSTALL};\
    su-exec node ghost install "${GHOST_VERSION}" --db sqlite3 --no-prompt --no-stack --no-setup --dir "${GHOST_INSTALL}"

ADD config.development.json ${GHOST_INSTALL}/versions/${GHOST_VERSION}/config.development.json
ADD start.sh /var/www/ghost/start.sh
RUN chmod +x start.sh
CMD ["./start.sh"]
