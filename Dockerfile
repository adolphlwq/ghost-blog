FROM ubuntu:16.04
MAINTAINER adolphlwq kenan3015@gmail.com

RUN apt-get update && \
    apt-get install -y vim npm=3.5.2-0ubuntu4 \
    ca-certificates \
		wget unzip \
	  --no-install-recommends && \
    ln -s /usr/bin/nodejs /usr/bin/node && \
    mkdir -p /opt/ghost

# install ghost
WORKDIR /opt/ghost
RUN wget https://ghost.org/zip/ghost-0.9.0.zip && \
    unzip ghost-0.9.0.zip && \
    npm install forever -g && \
    npm install --production

ENV NODE_ENV=production \
    USER=ghost
RUN useradd -m -U -u 1000 $USER && \
    chown $USER:$USER -R /opt/ghost && \
    chmod 755 -R /opt/ghost

# clean cache
RUN rm ghost-0.9.0.zip && \
    apt remove -y wget unzip && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    npm cache clean && \
    rm -rf /tmp/npm/*
    
EXPOSE 2368
ADD config.example.js /opt/ghost/config.js
USER $USER
# CMD ["forever", "start", "index.js"]
CMD ["npm", "start", "--production"]
