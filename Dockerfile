FROM node:4-alpine
MAINTAINER adolphlwq kenan3015@gmail.com

WORKDIR /var/www/ghost
ENV GHOST_ZIP_URL=https://github.com/TryGhost/Ghost/releases/download/1.0.0/Ghost-1.0.0.zip \
    GHOST_ZIP_NAME=Ghost-1.0.0.zip

RUN apk add --update --no-cache ca-certificates curl unzip && \
    rm -rf /var/cache/apk/

# download ghost zip and extract
RUN curl -Lo $GHOST_ZIP_NAME $GHOST_ZIP_URL && \
    unzip $GHOST_ZIP_NAME && \
    rm $GHOST_ZIP_NAME && \
    npm install && \
    npm install -g knex-migrator && \
    apk del curl unzip

ADD config.development.json /var/www/ghost/config.development.json
CMD ["knex-migrator", "init", "&&", "node", "index.js"]